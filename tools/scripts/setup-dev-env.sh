#!/bin/bash

# Development Environment Setup Script
# This script sets up a comprehensive development environment

set -e

echo "🚀 Setting up development environment..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install common development tools
install_dev_tools() {
    echo "📦 Installing development tools..."
    
    # Check for package manager and install tools accordingly
    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y git curl wget vim neovim htop tree jq
    elif command_exists brew; then
        brew install git curl wget vim neovim htop tree jq
    elif command_exists yum; then
        sudo yum install -y git curl wget vim neovim htop tree jq
    else
        echo "⚠️  Package manager not found. Please install tools manually."
    fi
}

# Setup Git configuration
setup_git() {
    echo "🔧 Setting up Git configuration..."
    
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Enter your Git username: " git_username
        git config --global user.name "$git_username"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Enter your Git email: " git_email
        git config --global user.email "$git_email"
    fi
    
    # Set useful Git aliases
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual '!gitk'
}

# Install Node.js and npm
install_nodejs() {
    echo "📦 Installing Node.js..."
    
    if ! command_exists node; then
        if command_exists curl; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        else
            echo "⚠️  Please install Node.js manually from https://nodejs.org"
        fi
    else
        echo "✅ Node.js already installed: $(node --version)"
    fi
}

# Install Python and pip
install_python() {
    echo "🐍 Installing Python..."
    
    if ! command_exists python3; then
        if command_exists apt-get; then
            sudo apt-get install -y python3 python3-pip
        elif command_exists brew; then
            brew install python3
        else
            echo "⚠️  Please install Python manually"
        fi
    else
        echo "✅ Python already installed: $(python3 --version)"
    fi
}

# Install Docker
install_docker() {
    echo "🐳 Installing Docker..."
    
    if ! command_exists docker; then
        if command_exists curl; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
            echo "⚠️  Please log out and back in to use Docker without sudo"
        else
            echo "⚠️  Please install Docker manually"
        fi
    else
        echo "✅ Docker already installed: $(docker --version)"
    fi
}

# Main execution
main() {
    echo "🎯 Starting development environment setup..."
    
    install_dev_tools
    setup_git
    install_nodejs
    install_python
    install_docker
    
    echo "✅ Development environment setup complete!"
    echo "📚 Check the docs/ folder for more configuration options."
}

# Run main function
main "$@"