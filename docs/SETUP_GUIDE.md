# 📖 Setup Guide

This guide will help you set up and use the ToolkitRepository for your development needs.

## 🚀 Quick Setup

### One-Command Setup
```bash
curl -fsSL https://raw.githubusercontent.com/Kaleaon/ToolkitRepository/main/scripts/setup-dev-environment.sh | bash
```

### Manual Setup

#### 1. System Requirements
- **Operating System**: Linux, macOS, or Windows (WSL)
- **Memory**: 8GB RAM minimum (16GB recommended)
- **Storage**: 10GB free space
- **Network**: Internet connection for downloading tools

#### 2. Clone Repository
```bash
git clone https://github.com/Kaleaon/ToolkitRepository.git
cd ToolkitRepository
```

#### 3. Run Setup Script
```bash
chmod +x scripts/setup-dev-environment.sh
./scripts/setup-dev-environment.sh
```

#### 4. Load Environment
```bash
source ~/.toolkit-env
# Add to your shell profile for persistence
echo "source ~/.toolkit-env" >> ~/.bashrc  # or ~/.zshrc
```

## 🔧 Configuration

### Environment Variables
After setup, these variables are available:

```bash
ANDROID_HOME      # Android SDK location
JAVA_HOME         # Java JDK location
PATH              # Updated with tool binaries
MAX_HEAP          # Maximum heap size for tools
GRADLE_OPTS       # Gradle optimization settings
```

### Tool Configuration

#### JADX Configuration
```bash
# Default heap size
export MAX_HEAP=4096

# Custom JADX options
jadx -j2 -Xmx${MAX_HEAP}m --show-bad-code app.apk
```

#### Android SDK Setup
```bash
# Accept licenses
yes | sdkmanager --licenses

# Install additional components
sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

## 📱 Android Development Setup

### 1. SDK Installation
The setup script installs Android SDK automatically, but you can also:

```bash
# Download command line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mkdir -p $HOME/Android/Sdk/cmdline-tools
mv cmdline-tools $HOME/Android/Sdk/cmdline-tools/latest
```

### 2. Gradle Configuration
For Android projects, use these Gradle configurations:

```kotlin
// build.gradle.kts
android {
    compileSdk 34
    buildToolsVersion "34.0.0"
    
    defaultConfig {
        minSdk 24
        targetSdk 34
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
```

## 🔍 Static Analysis Setup

### Tool Installation Verification
```bash
# Verify all tools are installed
jadx --version
apktool --version
java -version
d2j-dex2jar --help
```

### Analysis Workflow
1. **Prepare APK**: Place your APK file in the project directory
2. **Run Analysis**: Use the decompilation script
3. **Review Results**: Check the output directory structure

```bash
# Example analysis
./tools/apk_decompile.sh sample.apk

# Output structure
out/
├── jadx/          # Java source code
├── apktool/       # Resources and smali
├── dex2jar/       # Alternative decompilation
├── native/        # Native libraries
└── meta/          # File metadata
```

## 🐳 Docker Setup

### Build Environment
```bash
# Build development container
docker build -f build-configs/Dockerfile -t toolkit-dev .

# Run container with volume mount
docker run --rm -v $(pwd):/workspace toolkit-dev
```

### Docker Compose (Optional)
```yaml
# docker-compose.yml
version: '3.8'
services:
  toolkit:
    build: 
      context: .
      dockerfile: build-configs/Dockerfile
    volumes:
      - .:/workspace
    working_dir: /workspace
```

## 🚦 GitHub Actions Setup

### Repository Secrets
For full functionality, configure these secrets in your GitHub repository:

```bash
ANDROID_KEYSTORE_BASE64     # Base64 encoded keystore
ANDROID_KEYSTORE_PASSWORD   # Keystore password
ANDROID_KEY_ALIAS          # Key alias
ANDROID_KEY_PASSWORD       # Key password
GEMINI_API_KEY             # For AI triage (optional)
```

### Workflow Configuration
Copy workflows to your repository:

```bash
# Copy all workflows
cp -r .github/workflows/* /path/to/your/project/.github/workflows/

# Or copy specific workflows
cp .github/workflows/universal-build.yml /path/to/your/project/.github/workflows/
```

## 🔍 Troubleshooting

### Common Issues

#### Java Version Issues
```bash
# Check Java version
java -version

# Switch Java version (Ubuntu)
sudo update-alternatives --config java

# Set JAVA_HOME manually
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

#### Android SDK Issues
```bash
# Verify SDK location
echo $ANDROID_HOME
ls $ANDROID_HOME

# Reinstall SDK components
sdkmanager --install "platforms;android-33" "build-tools;33.0.2"
```

#### Tool Not Found Issues
```bash
# Check PATH
echo $PATH

# Reload environment
source ~/.toolkit-env

# Verify tool installation
which jadx
which apktool
```

#### Memory Issues
```bash
# Increase heap size
export MAX_HEAP=8192
export GRADLE_OPTS="-Xmx8g -XX:MaxMetaspaceSize=2g"
```

### Debugging Steps

1. **Check System Resources**
   ```bash
   free -h     # Memory usage
   df -h       # Disk space
   ```

2. **Verify Tool Installation**
   ```bash
   ./scripts/setup-dev-environment.sh verify
   ```

3. **Check Logs**
   ```bash
   # Gradle logs
   ./gradlew build --debug --stacktrace
   
   # Tool logs
   jadx --verbose app.apk
   ```

## 📚 Advanced Configuration

### Custom Tool Versions
```bash
# Override tool versions in setup script
export JADX_VERSION=1.5.0
export DEX2JAR_VERSION=2.1
export CFR_VERSION=0.152
```

### Performance Tuning
```bash
# High-performance configuration
export GRADLE_OPTS="-Xmx8g -XX:MaxMetaspaceSize=2g -XX:+UseG1GC -XX:+UseStringDeduplication"
export MAX_HEAP=8192

# Multi-threading
export JADX_THREADS=4
```

### Network Configuration
```bash
# Proxy settings (if needed)
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
export NO_PROXY=localhost,127.0.0.1
```

## 🎯 Next Steps

After successful setup:

1. **Test the Installation**: Run `jadx --version` and other tool commands
2. **Try Sample Analysis**: Use the provided sample scripts
3. **Integrate with Your Project**: Copy relevant workflows and configurations
4. **Customize for Your Needs**: Modify scripts and configurations as needed
5. **Explore Advanced Features**: Check out the documentation for advanced usage

## 📞 Getting Help

- **Documentation**: Check the `docs/` directory
- **Issues**: Create a GitHub issue with the bug report template
- **Discussions**: Use GitHub Discussions for questions
- **Community**: Join our community discussions

Remember to keep your tools updated and regularly sync with the latest repository changes!