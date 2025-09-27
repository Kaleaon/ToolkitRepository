# 🧰 ToolkitRepository

A comprehensive collection of development tools, GitHub Actions workflows, and utilities consolidated from multiple projects including CleverFerret and Linkpoint. This repository serves as a centralized toolkit for Android development, CI/CD automation, and static analysis.

## 📋 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [GitHub Actions Workflows](#-github-actions-workflows)
- [Tools & Scripts](#-tools--scripts)
- [Build Configurations](#-build-configurations)
- [Development Setup](#-development-setup)
- [Usage Examples](#-usage-examples)
- [Contributing](#-contributing)

## ✨ Features

### 🚀 GitHub Actions Workflows
- **Universal Build System**: Cross-platform Android/Java builds with architecture detection
- **Auto Copilot Triage**: Automated failure analysis with AI-powered issue triage
- **Static Analysis**: Comprehensive APK/binary analysis using JADX, Ghidra, and more
- **Nighty Builds**: Automated development builds with cleanup
- **Bulletproof CI/CD**: Robust build system with failure recovery

### 🔧 Development Tools
- **APK Decompilation**: Automated APK analysis and decompilation
- **Environment Setup**: One-command development environment installation
- **Static Analysis Tools**: Integration with JADX, apktool, dex2jar, CFR, and Ghidra
- **Docker Configurations**: Ready-to-use containerized build environments

### 📝 Templates & Configurations
- **Issue Templates**: Structured bug reports and feature requests
- **Build Configurations**: Gradle, Docker, and CI/CD configurations
- **Git Configurations**: Comprehensive .gitignore and best practices

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Kaleaon/ToolkitRepository.git
cd ToolkitRepository
```

### 2. Set Up Development Environment
```bash
./scripts/setup-dev-environment.sh
source ~/.toolkit-env
```

### 3. Use GitHub Actions
Copy any workflow from `.github/workflows/` to your project and customize as needed.

### 4. Analyze an APK
```bash
./tools/apk_decompile.sh path/to/your/app.apk
```

## 🔄 GitHub Actions Workflows

### Universal Build System
```yaml
# .github/workflows/universal-build.yml
name: Manual Universal Build System
on:
  workflow_dispatch:
    inputs:
      build_type:
        description: Build type
        required: true
        default: debug
        type: choice
        options: [debug, release]
```

**Features:**
- Architecture detection (x86_64, ARM64, ARMv7, x86)
- Multi-platform Android builds
- Comprehensive testing and validation
- Build artifact management

### Auto Copilot Triage
```yaml
# .github/workflows/auto-copilot-triage.yml
name: Auto Copilot Triage
on:
  workflow_run:
    workflows: ["*"]
    types: [completed]
```

**Features:**
- Automatic failure detection
- Log analysis and extraction
- AI-powered triage comments
- Pull request integration

### Static Analysis
```yaml
# .github/workflows/static-analysis.yml
name: Static Analysis Tools
on: [push, pull_request, workflow_dispatch]
```

**Features:**
- APK decompilation with JADX
- Resource extraction with apktool
- Alternative decompilation with dex2jar + CFR
- Native library analysis with Ghidra
- Comprehensive reporting

## 🛠️ Tools & Scripts

### APK Decompilation Tool
```bash
./tools/apk_decompile.sh app.apk
```

**Output Structure:**
```
out/
├── jadx/          # Java decompiled source
├── apktool/       # Resources and smali
├── dex2jar/       # Alternative decompilation
├── native/        # Extracted .so files
└── meta/          # File metadata
```

### Development Environment Setup
```bash
./scripts/setup-dev-environment.sh
```

**Installs:**
- Java 17 JDK
- Android SDK and build tools
- JADX decompiler
- dex2jar and CFR
- apktool
- Python 3 and pip

## 🏗️ Build Configurations

### Docker Configuration
```dockerfile
# build-configs/Dockerfile
FROM openjdk:17-jdk-slim
# Pre-configured Android build environment
```

### Gradle Configuration
Ready-to-use Gradle configurations with:
- Multi-architecture support
- Build optimization
- Testing frameworks
- Dependency management

## 💻 Development Setup

### Prerequisites
- Linux/macOS/Windows (WSL)
- Git
- Internet connection for downloading tools

### Automatic Setup
```bash
# Clone and setup in one command
git clone https://github.com/Kaleaon/ToolkitRepository.git
cd ToolkitRepository
./scripts/setup-dev-environment.sh
source ~/.toolkit-env
```

### Manual Setup
1. **Install Java 17**: Required for Android development
2. **Install Android SDK**: Use Android Studio or command-line tools
3. **Install Analysis Tools**: JADX, apktool, dex2jar, etc.
4. **Configure Environment**: Set ANDROID_HOME and PATH variables

## 📚 Usage Examples

### 1. Basic APK Analysis
```bash
# Download an APK and analyze it
wget https://example.com/app.apk
./tools/apk_decompile.sh app.apk

# View decompiled Java code
ls out/jadx/sources/
```

### 2. GitHub Actions Integration
```yaml
# In your repository's .github/workflows/build.yml
name: Build and Analyze
on: [push, pull_request]

jobs:
  build:
    uses: Kaleaon/ToolkitRepository/.github/workflows/universal-build.yml@main
    with:
      build_type: debug
```

### 3. Docker Build Environment
```bash
# Build using containerized environment
docker build -f build-configs/Dockerfile -t my-app-builder .
docker run --rm -v $(pwd):/app my-app-builder
```

### 4. Static Analysis Workflow
```bash
# Trigger static analysis workflow
gh workflow run static-analysis.yml -f artifact_path=app.apk
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### 1. Fork and Clone
```bash
git clone https://github.com/yourusername/ToolkitRepository.git
cd ToolkitRepository
```

### 2. Create Feature Branch
```bash
git checkout -b feature/awesome-new-tool
```

### 3. Make Changes
- Add new tools to `tools/`
- Add workflows to `.github/workflows/`
- Update documentation
- Add tests where applicable

### 4. Submit Pull Request
- Use the provided PR template
- Include clear description of changes
- Add tests for new functionality
- Update documentation

### Issue Reporting
Use our structured issue templates:
- 🐛 **Bug Report**: For reporting issues
- 💡 **Feature Request**: For suggesting new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

This toolkit consolidates and improves upon tools and configurations from:
- **CleverFerret**: Android CI/CD workflows and build automation
- **Linkpoint**: Static analysis tools and APK decompilation scripts
- **Community contributions**: Various open-source tools and best practices

## 📞 Support

- 📖 **Documentation**: Check the `docs/` directory for detailed guides
- 🐛 **Issues**: Use GitHub Issues with provided templates
- 💬 **Discussions**: Use GitHub Discussions for questions and ideas
- 📧 **Contact**: Open an issue for direct support

---

**Built with ❤️ for the developer community**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/Kaleaon/ToolkitRepository.svg)](https://github.com/Kaleaon/ToolkitRepository/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/Kaleaon/ToolkitRepository.svg)](https://github.com/Kaleaon/ToolkitRepository/issues)