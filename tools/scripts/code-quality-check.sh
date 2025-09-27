#!/bin/bash

# Code Quality Check Script
# Runs various code quality tools and generates reports

set -e

PROJECT_DIR=${1:-$(pwd)}
REPORT_DIR="$PROJECT_DIR/quality-reports"

echo "🔍 Running code quality checks for: $PROJECT_DIR"

# Create reports directory
mkdir -p "$REPORT_DIR"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Run linting for different languages
run_linters() {
    echo "🧹 Running linters..."
    
    # JavaScript/TypeScript
    if [ -f "$PROJECT_DIR/package.json" ]; then
        echo "📦 Checking JavaScript/TypeScript..."
        if command_exists eslint; then
            eslint "$PROJECT_DIR" --ext .js,.ts,.jsx,.tsx --format json > "$REPORT_DIR/eslint-report.json" 2>/dev/null || true
        fi
        
        if command_exists tsc; then
            tsc --noEmit --project "$PROJECT_DIR" > "$REPORT_DIR/typescript-check.log" 2>&1 || true
        fi
    fi
    
    # Python
    if find "$PROJECT_DIR" -name "*.py" -type f | head -1 | grep -q .; then
        echo "🐍 Checking Python..."
        if command_exists flake8; then
            flake8 "$PROJECT_DIR" --format=json --output-file="$REPORT_DIR/flake8-report.json" 2>/dev/null || true
        fi
        
        if command_exists pylint; then
            pylint "$PROJECT_DIR"/**/*.py --output-format=json > "$REPORT_DIR/pylint-report.json" 2>/dev/null || true
        fi
        
        if command_exists black; then
            black --check --diff "$PROJECT_DIR" > "$REPORT_DIR/black-report.log" 2>&1 || true
        fi
    fi
    
    # Go
    if [ -f "$PROJECT_DIR/go.mod" ]; then
        echo "🔷 Checking Go..."
        if command_exists golint; then
            golint "$PROJECT_DIR/..." > "$REPORT_DIR/golint-report.txt" 2>&1 || true
        fi
        
        if command_exists go; then
            go vet "$PROJECT_DIR/..." > "$REPORT_DIR/go-vet-report.txt" 2>&1 || true
        fi
    fi
    
    # Rust
    if [ -f "$PROJECT_DIR/Cargo.toml" ]; then
        echo "🦀 Checking Rust..."
        if command_exists cargo; then
            cargo clippy --all-targets --all-features -- -D warnings > "$REPORT_DIR/clippy-report.txt" 2>&1 || true
        fi
    fi
}

# Run security checks
run_security_checks() {
    echo "🔒 Running security checks..."
    
    # Check for secrets
    if command_exists gitleaks; then
        gitleaks detect --source "$PROJECT_DIR" --report-format json --report-path "$REPORT_DIR/secrets-report.json" 2>/dev/null || true
    fi
    
    # Dependency vulnerability check
    if [ -f "$PROJECT_DIR/package.json" ] && command_exists npm; then
        npm audit --json > "$REPORT_DIR/npm-audit.json" 2>/dev/null || true
    fi
    
    if [ -f "$PROJECT_DIR/requirements.txt" ] && command_exists safety; then
        safety check --json --file "$PROJECT_DIR/requirements.txt" > "$REPORT_DIR/python-safety.json" 2>/dev/null || true
    fi
}

# Generate complexity metrics
run_complexity_analysis() {
    echo "📊 Analyzing code complexity..."
    
    # Count lines of code
    if command_exists cloc; then
        cloc "$PROJECT_DIR" --json --out="$REPORT_DIR/loc-report.json" 2>/dev/null || true
    fi
    
    # Cyclomatic complexity for JavaScript
    if [ -f "$PROJECT_DIR/package.json" ] && command_exists plato; then
        plato -r -d "$REPORT_DIR/complexity" "$PROJECT_DIR/src" 2>/dev/null || true
    fi
}

# Generate summary report
generate_summary() {
    echo "📋 Generating summary report..."
    
    cat > "$REPORT_DIR/summary.md" << EOF
# Code Quality Report

Generated on: $(date)
Project: $PROJECT_DIR

## Files Analyzed
$(find "$PROJECT_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) | wc -l) source files

## Reports Generated
$(ls "$REPORT_DIR" | grep -v summary.md | while read file; do echo "- $file"; done)

## Next Steps
1. Review linting reports for code style issues
2. Address security vulnerabilities found in dependency audits
3. Check complexity reports for refactoring opportunities
4. Run tests to ensure code functionality

EOF
}

# Main execution
main() {
    echo "🎯 Starting code quality analysis..."
    
    run_linters
    run_security_checks
    run_complexity_analysis
    generate_summary
    
    echo "✅ Code quality check complete!"
    echo "📁 Reports saved to: $REPORT_DIR"
    echo "📋 Summary: $REPORT_DIR/summary.md"
}

# Run main function
main "$@"