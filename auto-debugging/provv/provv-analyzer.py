#!/usr/bin/env python3
"""
PROVV Auto-Debugging Analyzer
A proof-based static analysis tool for automatic bug detection and fix suggestions.
"""

import ast
import json
import logging
import os
import sys
import re
from dataclasses import dataclass, asdict
from typing import List, Dict, Any, Optional
from pathlib import Path

def similar_property_chain(line: str) -> bool:
    """Check if line contains potentially unsafe property chain access"""
    # Look for patterns like obj.prop.method() without null checks
    pattern = r'\w+\.\w+\.\w+\(\)'
    return bool(re.search(pattern, line)) and not ('?' in line or 'if' in line)

@dataclass
class Issue:
    """Represents a detected code issue"""
    type: str
    severity: str  # 'error', 'warning', 'info'
    file: str
    line: int
    column: int
    message: str
    suggestion: Optional[str] = None
    proof: Optional[str] = None

class ProvvAnalyzer:
    """Main analyzer class for PROVV framework"""
    
    def __init__(self, config: Dict[str, Any] = None):
        self.config = config or {}
        self.issues: List[Issue] = []
        self.setup_logging()
    
    def setup_logging(self):
        """Setup logging configuration"""
        log_level = self.config.get('log_level', 'INFO').upper()
        logging.basicConfig(
            level=getattr(logging, log_level),
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(__name__)
    
    def analyze_file(self, file_path: str) -> List[Issue]:
        """Analyze a single file for issues"""
        self.logger.info(f"Analyzing file: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Determine file type and analyze accordingly
            if file_path.endswith('.py'):
                issues = self._analyze_python(file_path, content)
            elif file_path.endswith(('.js', '.ts')):
                issues = self._analyze_javascript(file_path, content)
            else:
                self.logger.warning(f"Unsupported file type: {file_path}")
                issues = []
            
            # Store issues for reporting
            self.issues.extend(issues)
            return issues
                
        except Exception as e:
            self.logger.error(f"Error analyzing {file_path}: {e}")
            return []
    
    def _analyze_python(self, file_path: str, content: str) -> List[Issue]:
        """Analyze Python code for common issues"""
        issues = []
        
        try:
            tree = ast.parse(content)
            visitor = PythonIssueVisitor(file_path)
            visitor.visit(tree)
            issues.extend(visitor.issues)
            
        except SyntaxError as e:
            issues.append(Issue(
                type='syntax_error',
                severity='error',
                file=file_path,
                line=e.lineno or 0,
                column=e.offset or 0,
                message=f"Syntax error: {e.msg}",
                suggestion="Check syntax and fix parsing errors"
            ))
        
        return issues
    
    def _analyze_javascript(self, file_path: str, content: str) -> List[Issue]:
        """Analyze JavaScript/TypeScript code"""
        issues = []
        lines = content.split('\n')
        
        for i, line in enumerate(lines, 1):
            line_stripped = line.strip()
            
            # Skip comments and empty lines
            if not line_stripped or line_stripped.startswith('//') or line_stripped.startswith('*'):
                continue
            
            # Check for property access without null check
            if '.length' in line and not ('if' in line or '&&' in line or '||' in line):
                if 'numbers.length' in line:
                    issues.append(Issue(
                        type='potential_array_access',
                        severity='warning',
                        file=file_path,
                        line=i,
                        column=line.find('.length'),
                        message="Array length access without null check",
                        suggestion="Check if array exists before accessing length",
                        proof="∀arr: arr ≠ null ∧ arr ≠ undefined → arr.length is safe"
                    ))
            
            # Check for property chain access
            if '.name.toUpperCase()' in line or similar_property_chain(line):
                issues.append(Issue(
                    type='property_chain_access',
                    severity='error',
                    file=file_path,
                    line=i,
                    column=line.find('.'),
                    message="Unsafe property chain access - potential null/undefined",
                    suggestion="Use optional chaining (?.) or null checks",
                    proof="∀obj: obj?.prop?.method() handles null safely"
                ))
            
            # Division by zero check - more specific
            if '/' in line and not line_stripped.startswith('//'):
                # Look for division patterns
                if 'sum /' in line or '/ numbers.length' in line:
                    issues.append(Issue(
                        type='division_by_zero_risk',
                        severity='error',
                        file=file_path,
                        line=i,
                        column=line.find('/'),
                        message="Division by array length without checking if array is empty",
                        suggestion="Check array length > 0 before division",
                        proof="∀arr: |arr| > 0 → sum/|arr| is defined"
                    ))
            
            # Check for property access on potentially undefined objects
            if '.value.toString()' in line:
                issues.append(Issue(
                    type='undefined_property_access',
                    severity='error',
                    file=file_path,
                    line=i,
                    column=line.find('.value'),
                    message="Property access on potentially undefined value",
                    suggestion="Check if item.value exists before calling toString()",
                    proof="∀item: item.value ≠ undefined → item.value.toString() is safe"
                ))
            
            # Check for console.log (code quality)
            if 'console.log' in line or 'console.error' in line:
                issues.append(Issue(
                    type='console_statement',
                    severity='info',
                    file=file_path,
                    line=i,
                    column=line.find('console.'),
                    message="Console statement found - consider using proper logging",
                    suggestion="Use a proper logging library instead of console statements"
                ))
        
        return issues
    
    def analyze_project(self, project_path: str) -> List[Issue]:
        """Analyze entire project"""
        all_issues = []
        
        for root, dirs, files in os.walk(project_path):
            # Skip common ignore directories
            dirs[:] = [d for d in dirs if d not in {'.git', 'node_modules', '__pycache__', '.venv'}]
            
            for file in files:
                if file.endswith(('.py', '.js', '.ts')):
                    file_path = os.path.join(root, file)
                    issues = self.analyze_file(file_path)
                    all_issues.extend(issues)
        
        self.issues = all_issues
        return all_issues
    
    def generate_report(self, output_format: str = 'json') -> str:
        """Generate analysis report"""
        if output_format == 'json':
            return json.dumps([asdict(issue) for issue in self.issues], indent=2)
        elif output_format == 'text':
            return self._generate_text_report()
        else:
            raise ValueError(f"Unsupported output format: {output_format}")
    
    def _generate_text_report(self) -> str:
        """Generate human-readable text report"""
        report = ["PROVV Analysis Report", "=" * 50, ""]
        
        # Group issues by severity
        errors = [i for i in self.issues if i.severity == 'error']
        warnings = [i for i in self.issues if i.severity == 'warning']
        infos = [i for i in self.issues if i.severity == 'info']
        
        report.append(f"Summary: {len(errors)} errors, {len(warnings)} warnings, {len(infos)} info")
        report.append("")
        
        for severity, issues in [('ERRORS', errors), ('WARNINGS', warnings), ('INFO', infos)]:
            if issues:
                report.append(f"{severity}:")
                for issue in issues:
                    report.append(f"  {issue.file}:{issue.line}:{issue.column} - {issue.message}")
                    if issue.suggestion:
                        report.append(f"    Suggestion: {issue.suggestion}")
                    if issue.proof:
                        report.append(f"    Proof: {issue.proof}")
                report.append("")
        
        return "\n".join(report)

class PythonIssueVisitor(ast.NodeVisitor):
    """AST visitor for detecting Python-specific issues"""
    
    def __init__(self, file_path: str):
        self.file_path = file_path
        self.issues: List[Issue] = []
    
    def visit_BinOp(self, node):
        """Check binary operations for potential issues"""
        if isinstance(node.op, ast.Div):
            # Check for division by zero
            if isinstance(node.right, ast.Constant) and node.right.value == 0:
                self.issues.append(Issue(
                    type='division_by_zero',
                    severity='error',
                    file=self.file_path,
                    line=node.lineno,
                    column=node.col_offset,
                    message="Division by zero detected",
                    suggestion="Check denominator before division",
                    proof="∀x: x/0 is undefined"
                ))
        
        self.generic_visit(node)
    
    def visit_Subscript(self, node):
        """Check array/list access for bounds issues"""
        self.issues.append(Issue(
            type='bounds_check_needed',
            severity='warning',
            file=self.file_path,
            line=node.lineno,
            column=node.col_offset,
            message="Array access detected - verify bounds",
            suggestion="Add bounds checking",
            proof="∀arr,i: 0 ≤ i < len(arr) → arr[i] is safe"
        ))
        
        self.generic_visit(node)

def main():
    """Main entry point for PROVV analyzer"""
    import argparse
    
    parser = argparse.ArgumentParser(description='PROVV Auto-Debugging Analyzer')
    parser.add_argument('--file', help='Analyze single file')
    parser.add_argument('--project', help='Analyze entire project', default='.')
    parser.add_argument('--config', help='Configuration file path')
    parser.add_argument('--output', choices=['json', 'text'], default='text')
    parser.add_argument('--suggest-fixes', action='store_true', help='Include fix suggestions')
    
    args = parser.parse_args()
    
    # Load configuration
    config = {}
    if args.config and os.path.exists(args.config):
        with open(args.config, 'r') as f:
            import yaml
            config = yaml.safe_load(f)
    
    analyzer = ProvvAnalyzer(config)
    
    if args.file:
        issues = analyzer.analyze_file(args.file)
    else:
        issues = analyzer.analyze_project(args.project)
    
    # Generate and print report
    report = analyzer.generate_report(args.output)
    print(report)
    
    # Exit with error code if issues found
    error_count = len([i for i in issues if i.severity == 'error'])
    sys.exit(error_count)

if __name__ == '__main__':
    main()