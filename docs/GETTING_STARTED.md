# Getting Started with ToolkitRepository

This guide will help you get up and running with the ToolkitRepository tools and configurations.

## Prerequisites

- Git
- Basic command line knowledge
- One or more of: Node.js, Python, Go, or Rust (depending on your project)

## Step 1: Clone and Setup

```bash
# Clone the repository
git clone https://github.com/Kaleaon/ToolkitRepository.git
cd ToolkitRepository

# Make scripts executable (if not already done)
chmod +x tools/scripts/*.sh
chmod +x auto-debugging/provv/*.py
```

## Step 2: Environment Setup

Run the environment setup script to install common development tools:

```bash
./tools/scripts/setup-dev-env.sh
```

This script will:
- Install Git and configure it
- Install Node.js and npm
- Install Python and pip
- Install Docker
- Set up useful Git aliases

## Step 3: Integrate with Your Project

### Option A: Copy Configuration Files

Copy the configuration templates you need to your project:

```bash
# Copy PROVV configuration
cp configs/yaml-templates/.provv.yml /path/to/your/project/

# Copy Docker development setup
cp configs/yaml-templates/docker-compose.dev.yml /path/to/your/project/

# Copy CI/CD pipeline configuration
cp configs/yaml-templates/github-actions-ci.yml /path/to/your/project/.github/workflows/
```

### Option B: Reference Tools Directly

Add scripts to your package.json that reference the toolkit tools:

```json
{
  "scripts": {
    "quality-check": "path/to/ToolkitRepository/tools/scripts/code-quality-check.sh",
    "provv": "python3 path/to/ToolkitRepository/auto-debugging/provv/provv-analyzer.py --project .",
    "setup-env": "path/to/ToolkitRepository/tools/scripts/setup-dev-env.sh"
  }
}
```

## Step 4: Run Code Analysis

### Basic Quality Check

Run a comprehensive code quality check on your project:

```bash
./tools/scripts/code-quality-check.sh /path/to/your/project
```

This will generate reports in `/path/to/your/project/quality-reports/`.

### PROVV Auto-Debugging

Analyze your code with the PROVV framework:

```bash
# Analyze entire project
python3 auto-debugging/provv/provv-analyzer.py --project /path/to/your/project

# Analyze single file
python3 auto-debugging/provv/provv-analyzer.py --file /path/to/your/file.py

# Get JSON output for CI integration
python3 auto-debugging/provv/provv-analyzer.py --project . --output json
```

## Step 5: Development Environment

### Using Docker Compose

Start a complete development environment:

```bash
# Copy and customize the docker-compose file
cp configs/yaml-templates/docker-compose.dev.yml ./docker-compose.yml

# Edit environment variables as needed
nano docker-compose.yml

# Start the development stack
docker-compose up -d
```

This provides:
- Your application with debugging enabled
- PostgreSQL database
- Redis cache
- Nginx reverse proxy
- Monitoring stack (Prometheus + Grafana)
- MailHog for email testing

### Access Points

- Application: http://localhost:3000
- Database: localhost:5432
- Redis: localhost:6379
- Grafana: http://localhost:3001
- MailHog: http://localhost:8025

## Step 6: CI/CD Integration

### GitHub Actions

Copy the CI/CD template to your repository:

```bash
mkdir -p .github/workflows
cp configs/yaml-templates/github-actions-ci.yml .github/workflows/ci.yml
```

Customize the workflow for your project needs and push to GitHub.

### Environment Variables

Set these secrets in your GitHub repository:
- `CODECOV_TOKEN` - For code coverage reporting
- `SLACK_WEBHOOK` - For deployment notifications
- `GRAFANA_PASSWORD` - For Grafana access

## Step 7: Customization

### PROVV Configuration

Edit `.provv.yml` in your project root to customize analysis:

```yaml
analysis:
  strict_mode: true
  check_types: true
  
languages:
  python:
    rules:
      - "division-by-zero"
      - "type-hints"
```

### Adding Custom Rules

You can add custom rules to PROVV:

```yaml
custom_rules:
  - name: "no-console-log"
    pattern: "console\\.log"
    severity: "warning"
    message: "Remove console.log before production"
```

## Common Workflows

### Daily Development

```bash
# 1. Pull latest changes
git pull

# 2. Run quality check
npm run quality-check

# 3. Run PROVV analysis
npm run provv

# 4. Fix any issues found
# ... make your changes ...

# 5. Run tests
npm test

# 6. Commit and push
git add .
git commit -m "Fix quality issues"
git push
```

### Pre-commit Hook

Add a pre-commit hook to automatically run checks:

```bash
# .git/hooks/pre-commit
#!/bin/bash
npm run provv --output json | jq -e '.[] | select(.severity == "error") | length == 0'
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure scripts are executable
   ```bash
   chmod +x tools/scripts/*.sh
   ```

2. **Python Dependencies**: Install required packages
   ```bash
   pip install pyyaml ast
   ```

3. **Node.js Tools**: Install ESLint and Prettier globally
   ```bash
   npm install -g eslint prettier
   ```

### Getting Help

- Check the examples in `examples/` directory
- Review configuration templates in `configs/`
- Open an issue on GitHub for bugs or questions

## Next Steps

- Explore the `examples/basic-setup/` directory for a complete project example
- Read the PROVV documentation in `auto-debugging/provv/README.md`
- Customize the configurations for your specific project needs
- Set up monitoring and alerting for your applications

Happy coding! 🚀