# ToolkitRepository

A comprehensive collection of development tools, configurations, and auto-debugging frameworks to streamline your coding workflow.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/Kaleaon/ToolkitRepository.git
cd ToolkitRepository

# Setup development environment
chmod +x tools/scripts/setup-dev-env.sh
./tools/scripts/setup-dev-env.sh

# Run code quality check on your project
./tools/scripts/code-quality-check.sh /path/to/your/project
```

## 📁 Repository Structure

```
ToolkitRepository/
├── tools/                          # Development tools and utilities
│   ├── scripts/                    # Automation scripts
│   │   ├── setup-dev-env.sh       # Environment setup
│   │   └── code-quality-check.sh  # Quality analysis
│   ├── linters/                    # Code linting configurations
│   ├── formatters/                 # Code formatting tools
│   └── build-tools/                # Build and compilation tools
├── configs/                        # Configuration templates
│   ├── yaml-templates/             # YAML configuration files
│   │   ├── docker-compose.dev.yml # Development Docker setup
│   │   └── github-actions-ci.yml  # CI/CD pipeline
│   ├── docker/                     # Docker configurations
│   ├── ci-cd/                      # CI/CD templates
│   └── environments/               # Environment-specific configs
├── auto-debugging/                 # Auto-debugging framework
│   ├── provv/                      # PROVV debugging system
│   │   ├── README.md              # PROVV documentation
│   │   └── provv-analyzer.py      # Main analyzer
│   ├── analyzers/                  # Code analyzers
│   └── monitors/                   # Runtime monitors
├── examples/                       # Usage examples
│   └── basic-setup/                # Basic project setup example
├── docs/                           # Documentation
└── README.md                       # This file
```

## 🛠️ Tools Overview

### Development Scripts

#### Environment Setup (`tools/scripts/setup-dev-env.sh`)
Automatically sets up a complete development environment with:
- Git configuration
- Node.js and npm
- Python and pip
- Docker
- Common development tools

#### Code Quality Check (`tools/scripts/code-quality-check.sh`)
Comprehensive code analysis including:
- Multi-language linting (JavaScript, Python, Go, Rust)
- Security vulnerability scanning
- Dependency auditing
- Complexity analysis
- Automated reporting

### Configuration Templates

#### Docker Development (`configs/yaml-templates/docker-compose.dev.yml`)
Complete development stack with:
- Application container with debugging
- PostgreSQL database
- Redis cache
- Nginx reverse proxy
- Monitoring (Prometheus, Grafana)
- Development tools (MailHog)

#### CI/CD Pipeline (`configs/yaml-templates/github-actions-ci.yml`)
Production-ready GitHub Actions workflow featuring:
- Multi-matrix testing
- Security scanning
- Dependency checking
- Containerization
- Automated deployment

## 🔍 Auto-Debugging with PROVV

PROVV (Proof-Oriented Verification and Validation) is an intelligent debugging framework that:

- **Static Analysis**: Detects issues before runtime
- **Formal Proofs**: Generates mathematical proofs for code correctness
- **Smart Suggestions**: Provides intelligent fix recommendations
- **Multi-language Support**: Works with JavaScript, Python, Go, and Rust

### Usage

```bash
# Analyze a single file
python3 auto-debugging/provv/provv-analyzer.py --file src/main.py

# Analyze entire project
python3 auto-debugging/provv/provv-analyzer.py --project .

# Get fix suggestions
python3 auto-debugging/provv/provv-analyzer.py --project . --suggest-fixes
```

### Example Output

```
PROVV Analysis Report
==================================================

Summary: 0 errors, 2 warnings, 1 info

WARNINGS:
  src/app.js:15:8 - Potential null pointer dereference
    Suggestion: Add null check before property access
    Proof: ∀x: x ≠ null → x.prop is safe

  src/utils.js:23:10 - Potential division by zero
    Suggestion: Add check for zero denominator
    Proof: ∀x,y: y ≠ 0 → x/y is defined
```

## 📚 Usage Examples

### Basic Project Setup

See `examples/basic-setup/` for a complete example project that demonstrates:
- Package.json with all recommended scripts
- ESLint and Prettier configuration
- Jest testing setup
- Docker integration
- PROVV analysis integration

### Quick Integration

Add to your project's package.json:

```json
{
  "scripts": {
    "quality-check": "path/to/ToolkitRepository/tools/scripts/code-quality-check.sh",
    "provv": "python3 path/to/ToolkitRepository/auto-debugging/provv/provv-analyzer.py --project .",
    "setup-env": "path/to/ToolkitRepository/tools/scripts/setup-dev-env.sh"
  }
}
```

## 🎯 Supported Languages

- **JavaScript/TypeScript**: ESLint, Prettier, TypeScript compiler
- **Python**: Flake8, Black, Pylint, Safety
- **Go**: Go vet, Golint
- **Rust**: Clippy
- **Docker**: Hadolint
- **YAML**: yamllint

## 🔧 Configuration

Most tools can be configured through:
- `.provv.yml` - PROVV analyzer configuration
- `package.json` - JavaScript/Node.js settings
- `pyproject.toml` - Python project configuration
- Environment variables for Docker and CI/CD

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your tools or configurations
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - feel free to use these tools in your projects!

## 🆘 Support

- Check the `docs/` directory for detailed documentation
- Review `examples/` for usage patterns
- Open an issue for bugs or feature requests

---

**Made with ❤️ for developers who want better code quality and fewer bugs!**