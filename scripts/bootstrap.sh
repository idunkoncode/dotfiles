#!/bin/bash

# Dotfiles bootstrap script for fresh systems
# This script can be run on any Linux distribution or macOS

set -e

DOTFILES_REPO="https://github.com/idunkoncode/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "🚀 Bootstrapping dotfiles setup..."

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS and distribution
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$NAME
            DISTRO=$ID
        elif [ -f /etc/redhat-release ]; then
            OS="Red Hat"
            DISTRO="rhel"
        elif [ -f /etc/debian_version ]; then
            OS="Debian"
            DISTRO="debian"
        else
            OS="Linux"
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        DISTRO="macos"
    else
        OS="Unknown"
        DISTRO="unknown"
    fi
    
    echo "🖥️  Detected OS: $OS ($DISTRO)"
}

# Install git if not present
install_git() {
    if ! command_exists git; then
        echo "📦 Installing git..."
        
        case $DISTRO in
            ubuntu|debian)
                if command_exists apt-get; then
                    sudo apt-get update -qq
                    sudo apt-get install -y git
                elif command_exists apt; then
                    sudo apt update -qq
                    sudo apt install -y git
                fi
                ;;
            fedora|rhel|centos)
                if command_exists dnf; then
                    sudo dnf install -y git
                elif command_exists yum; then
                    sudo yum install -y git
                fi
                ;;
            arch|manjaro)
                if command_exists pacman; then
                    sudo pacman -S --noconfirm git
                fi
                ;;
            opensuse*)
                if command_exists zypper; then
                    sudo zypper install -y git
                fi
                ;;
            macos)
                if command_exists brew; then
                    brew install git
                else
                    echo "⚠️  Please install Homebrew first or install git manually"
                    exit 1
                fi
                ;;
            *)
                echo "⚠️  Unsupported distribution: $DISTRO"
                echo "📝 Please install git manually"
                exit 1
                ;;
        esac
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        echo "📁 Dotfiles directory already exists at $DOTFILES_DIR"
        echo "🔄 Updating existing repository..."
        cd "$DOTFILES_DIR"
        git pull origin master || git pull origin main
    else
        echo "📥 Cloning dotfiles repository..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
}

# Make scripts executable
make_scripts_executable() {
    echo "🔧 Making scripts executable..."
    chmod +x "$DOTFILES_DIR/scripts"/*.sh
}

# Run installation
run_installation() {
    echo "▶️  Running installation script..."
    cd "$DOTFILES_DIR"
    ./scripts/install.sh
}

# Main execution
main() {
    detect_os
    install_git
    clone_dotfiles
    make_scripts_executable
    run_installation
    
    echo ""
    echo "🎉 Bootstrap complete!"
    echo "📁 Dotfiles are located at: $DOTFILES_DIR"
    echo "🔄 Restart your shell or run 'exec $SHELL' to reload configuration"
    echo ""
    echo "🌟 To update dotfiles in the future, run:"
    echo "   cd $DOTFILES_DIR && ./scripts/update.sh"
}

# Run if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
