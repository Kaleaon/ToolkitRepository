#!/bin/bash
set -euo pipefail

# Development Environment Setup Script
# This script sets up a development environment with all necessary tools

echo "🚀 Setting up development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on supported system
check_system() {
    print_status "Checking system compatibility..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "Detected Linux system"
        PACKAGE_MANAGER="apt"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Detected macOS system"
        PACKAGE_MANAGER="brew"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Install system dependencies
install_dependencies() {
    print_status "Installing system dependencies..."
    
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo apt-get update
        sudo apt-get install -y \
            curl \
            wget \
            unzip \
            git \
            build-essential \
            python3 \
            python3-pip \
            openjdk-17-jdk \
            apktool
    elif [[ "$PACKAGE_MANAGER" == "brew" ]]; then
        brew update
        brew install \
            curl \
            wget \
            unzip \
            git \
            python3 \
            openjdk@17 \
            apktool
    fi
}

# Install Android SDK
install_android_sdk() {
    print_status "Installing Android SDK..."
    
    ANDROID_HOME="$HOME/Android/Sdk"
    mkdir -p "$ANDROID_HOME"
    
    if [[ ! -d "$ANDROID_HOME/cmdline-tools" ]]; then
        print_status "Downloading Android command line tools..."
        cd /tmp
        wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
        unzip -q commandlinetools-linux-9477386_latest.zip
        mkdir -p "$ANDROID_HOME/cmdline-tools"
        mv cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
        rm commandlinetools-linux-9477386_latest.zip
    fi
    
    # Add to PATH
    export ANDROID_HOME="$ANDROID_HOME"
    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
    
    # Accept licenses and install components
    print_status "Installing Android SDK components..."
    yes | sdkmanager --licenses 2>/dev/null || true
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"
}

# Install analysis tools
install_analysis_tools() {
    print_status "Installing analysis tools..."
    
    # Create tools directory
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/opt"
    
    # Install JADX
    if [[ ! -f "$HOME/.local/bin/jadx" ]]; then
        print_status "Installing JADX..."
        cd /tmp
        JADX_VER=1.5.0
        wget -q "https://github.com/skylot/jadx/releases/download/v${JADX_VER}/jadx-${JADX_VER}.zip"
        unzip -q "jadx-${JADX_VER}.zip" -d "$HOME/.local/opt/jadx"
        ln -sf "$HOME/.local/opt/jadx/bin/jadx" "$HOME/.local/bin/jadx"
        rm "jadx-${JADX_VER}.zip"
    fi
    
    # Install dex2jar
    if [[ ! -f "$HOME/.local/bin/d2j-dex2jar" ]]; then
        print_status "Installing dex2jar..."
        cd /tmp
        D2J_VER=2.1
        wget -q "https://github.com/pxb1988/dex2jar/releases/download/v${D2J_VER}/dex2jar-${D2J_VER}.zip"
        unzip -q "dex2jar-${D2J_VER}.zip" -d "$HOME/.local/opt/"
        ln -sf "$HOME/.local/opt/dex2jar-${D2J_VER}/d2j-dex2jar.sh" "$HOME/.local/bin/d2j-dex2jar"
        rm "dex2jar-${D2J_VER}.zip"
    fi
    
    # Install CFR
    if [[ ! -f "$HOME/.local/opt/cfr.jar" ]]; then
        print_status "Installing CFR..."
        CFR_VER=0.152
        wget -q "https://www.benf.org/other/cfr/cfr-${CFR_VER}.jar" -O "$HOME/.local/opt/cfr.jar"
    fi
    
    # Add to PATH
    export PATH="$PATH:$HOME/.local/bin"
}

# Create environment file
create_environment_file() {
    print_status "Creating environment configuration..."
    
    cat > "$HOME/.toolkit-env" << EOF
# Toolkit Development Environment
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH="\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:$HOME/.local/bin"

# Tool configurations
export MAX_HEAP=4096
export GRADLE_OPTS="-Xmx4g -XX:MaxMetaspaceSize=1g -XX:+UseG1GC"

# Aliases
alias jadx-gui="jadx-gui"
alias apk-analyze="$HOME/.local/bin/apk_decompile.sh"
EOF
    
    print_status "Environment file created at ~/.toolkit-env"
    print_status "Add 'source ~/.toolkit-env' to your shell profile to load these settings"
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    # Source environment
    source "$HOME/.toolkit-env"
    
    # Check tools
    tools=("java" "javac" "git" "python3" "apktool" "jadx" "d2j-dex2jar")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            print_status "✅ $tool: Available"
        else
            print_warning "⚠️  $tool: Not found"
        fi
    done
    
    # Check Android SDK
    if [[ -d "$ANDROID_HOME" ]]; then
        print_status "✅ Android SDK: Available at $ANDROID_HOME"
    else
        print_warning "⚠️  Android SDK: Not found"
    fi
}

# Main installation process
main() {
    print_status "🛠️  Toolkit Development Environment Setup"
    print_status "========================================="
    
    check_system
    install_dependencies
    install_android_sdk
    install_analysis_tools
    create_environment_file
    verify_installation
    
    print_status ""
    print_status "🎉 Setup completed!"
    print_status ""
    print_status "Next steps:"
    print_status "1. Run 'source ~/.toolkit-env' to load environment variables"
    print_status "2. Add 'source ~/.toolkit-env' to your ~/.bashrc or ~/.zshrc"
    print_status "3. Test the installation by running 'jadx --version'"
    print_status ""
    print_status "Happy coding! 🚀"
}

# Run main function
main "$@"