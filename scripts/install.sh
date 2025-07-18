#!/bin/bash

# Cross-distribution dotfiles installation script
set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🚀 Installing dotfiles..."

# Detect OS and distribution
detect_os() {
    # Check if we're on Linux (including when OSTYPE is not set in Fish)
    if [[ "$OSTYPE" == "linux"* ]] || [[ "$OSTYPE" == "" && "$(uname -s)" == "Linux" ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$NAME
            DISTRO=$ID
            VERSION_ID=${VERSION_ID:-""}
            
            # Special handling for openSUSE variants
            case "$DISTRO" in
                "opensuse-tumbleweed"|"opensuse-leap"|"opensuse-slowroll")
                    DISTRO="opensuse"
                    ;;
                "opensuse"*)
                    DISTRO="opensuse"
                    ;;
            esac
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
    elif [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "" && "$(uname -s)" == "Darwin" ]]; then
        OS="macOS"
        DISTRO="macos"
    else
        OS="Unknown"
        DISTRO="unknown"
    fi
    
    echo "🖥️  Detected OS: $OS ($DISTRO)"
    [ -n "$VERSION_ID" ] && echo "📋 Version: $VERSION_ID"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install package based on distribution
install_package() {
    local package="$1"
    local package_apt="$2"
    local package_yum="$3"
    local package_pacman="$4"
    local package_brew="$5"
    
    echo "📦 Installing $package..."
    
    case $DISTRO in
        ubuntu|debian)
            if command_exists apt-get; then
                sudo apt-get update -qq
                sudo apt-get install -y "${package_apt:-$package}"
            elif command_exists apt; then
                sudo apt update -qq
                sudo apt install -y "${package_apt:-$package}"
            fi
            ;;
        fedora|rhel|centos)
            if command_exists dnf; then
                sudo dnf install -y "${package_yum:-$package}"
            elif command_exists yum; then
                sudo yum install -y "${package_yum:-$package}"
            fi
            ;;
        arch|manjaro)
            if command_exists pacman; then
                sudo pacman -S --noconfirm "${package_pacman:-$package}"
            elif command_exists yay; then
                yay -S --noconfirm "${package_pacman:-$package}"
            fi
            ;;
        opensuse|opensuse*)
            if command_exists zypper; then
                sudo zypper install --no-recommends -y "${package_yum:-$package}"
            fi
            ;;
        macos)
            if command_exists brew; then
                brew install "${package_brew:-$package}"
            else
                echo "⚠️  Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        *)
            echo "⚠️  Unsupported distribution: $DISTRO"
            echo "📝 Please install $package manually"
            return 1
            ;;
    esac
}

# Install dependencies
install_dependencies() {
    echo "📋 Installing dependencies..."
    
    # Essential tools
    if ! command_exists git; then
        install_package "git" "git" "git" "git" "git"
    fi
    
    if ! command_exists curl; then
        install_package "curl" "curl" "curl" "curl" "curl"
    fi
    
    if ! command_exists wget; then
        install_package "wget" "wget" "wget" "wget" "wget"
    fi
    
    # Fish shell
    if ! command_exists fish; then
        echo "🐟 Installing Fish shell..."
        install_package "fish" "fish" "fish" "fish" "fish"
    fi
    
    # Ghostty terminal emulator
    if ! command_exists ghostty; then
        echo "👻 Installing Ghostty terminal emulator..."
        install_package "ghostty" "ghostty" "ghostty" "ghostty" "ghostty"
    fi
    
    # Oh My Posh
    if ! command_exists oh-my-posh; then
        echo "🎨 Installing Oh My Posh..."
        install_oh_my_posh
    fi
    
    # GitHub CLI for dotfiles sync
    if ! command_exists gh; then
        echo "🐙 Installing GitHub CLI..."
        install_package "gh" "gh" "gh" "github-cli" "gh"
    fi
    
    # Cron service for automated sync
    if ! command_exists crontab; then
        echo "⏰ Installing cron service..."
        case $DISTRO in
            ubuntu|debian)
                install_package "cron" "cron" "cron" "cron" "cron"
                ;;
            fedora|rhel|centos)
                install_package "cronie" "cronie" "cronie" "cronie" "cronie"
                ;;
            arch|manjaro)
                install_package "cronie" "cronie" "cronie" "cronie" "cronie"
                ;;
            opensuse|opensuse*)
                install_package "cronie" "cronie" "cronie" "cronie" "cronie"
                ;;
            macos)
                echo "ℹ️  Cron is built into macOS"
                ;;
            *)
                echo "⚠️  Please install cron manually for your distribution"
                ;;
        esac
    fi
    
    # Optional tools
    if ! command_exists vim; then
        install_package "vim" "vim" "vim" "vim" "vim"
    fi
    
    if ! command_exists tmux; then
        install_package "tmux" "tmux" "tmux" "tmux" "tmux"
    fi
    
    if ! command_exists rsync; then
        install_package "rsync" "rsync" "rsync" "rsync" "rsync"
    fi

    # Desktop notifications for sync feedback
    if ! command_exists notify-send; then
        case $DISTRO in
            ubuntu|debian)
                install_package "libnotify-bin" "libnotify-bin" "libnotify" "libnotify" "libnotify"
                ;;
            fedora|rhel|centos)
                install_package "libnotify" "libnotify" "libnotify" "libnotify" "libnotify"
                ;;
            arch|manjaro)
                install_package "libnotify" "libnotify" "libnotify" "libnotify" "libnotify"
                ;;
            opensuse|opensuse*)
                install_package "libnotify-tools" "libnotify-tools" "libnotify-tools" "libnotify" "libnotify"
                ;;
            macos)
                echo "ℹ️  macOS has built-in notification system"
                ;;
            *)
                echo "⚠️  Please install libnotify/notify-send manually for desktop notifications"
                ;;
        esac
    fi
    
    # Font tools for Nerd Fonts
    if ! command_exists fc-cache; then
        case $DISTRO in
            ubuntu|debian)
                install_package "fontconfig" "fontconfig" "fontconfig" "fontconfig" "fontconfig"
                ;;
            fedora|rhel|centos)
                install_package "fontconfig" "fontconfig" "fontconfig" "fontconfig" "fontconfig"
                ;;
            arch|manjaro)
                install_package "fontconfig" "fontconfig" "fontconfig" "fontconfig" "fontconfig"
                ;;
            opensuse|opensuse*)
                install_package "fontconfig" "fontconfig" "fontconfig" "fontconfig" "fontconfig"
                ;;
            macos)
                echo "ℹ️  fontconfig available via Homebrew if needed"
                ;;
            *)
                echo "⚠️  Please install fontconfig manually for font management"
                ;;
        esac
    fi
}

# Install Oh My Posh
install_oh_my_posh() {
    local install_dir="$HOME/.local/bin"
    mkdir -p "$install_dir"
    
    if [[ "$OSTYPE" == "linux"* ]] || [[ "$OSTYPE" == "" && "$(uname -s)" == "Linux" ]]; then
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$install_dir"
    elif [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "" && "$(uname -s)" == "Darwin" ]]; then
        if command_exists brew; then
            brew install jandedobbeleer/oh-my-posh/oh-my-posh
        else
            curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$install_dir"
        fi
    fi
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        export PATH="$install_dir:$PATH"
    fi
}

# Detect OS first
detect_os

# Install dependencies
install_dependencies

# Create necessary directories
mkdir -p "$CONFIG_DIR"

# Function to create symlinks safely
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        echo "🔗 Removing existing symlink: $target"
        rm "$target"
    elif [ -e "$target" ]; then
        echo "📁 Backing up existing file: $target -> $target.backup"
        mv "$target" "$target.backup"
    fi
    
    echo "🔗 Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Install config files
echo "📁 Installing config files..."
create_symlink "$DOTFILES_DIR/config/fish" "$CONFIG_DIR/fish"
create_symlink "$DOTFILES_DIR/config/ghostty" "$CONFIG_DIR/ghostty"
create_symlink "$DOTFILES_DIR/config/nvim" "$CONFIG_DIR/nvim"

# Install config files for git
if [ -d "$DOTFILES_DIR/config/git" ]; then
    create_symlink "$DOTFILES_DIR/config/git" "$CONFIG_DIR/git"
fi

# Install config files for Oh My Posh
if [ -d "$DOTFILES_DIR/config/oh-my-posh" ]; then
    create_symlink "$DOTFILES_DIR/config/oh-my-posh" "$CONFIG_DIR/oh-my-posh"
fi

# Install home directory files
echo "🏠 Installing home directory files..."
create_symlink "$DOTFILES_DIR/home/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/home/.profile" "$HOME/.profile"

# Check if additional configs exist and install them
if [ -f "$DOTFILES_DIR/home/.gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
fi

if [ -f "$DOTFILES_DIR/home/.vimrc" ]; then
    create_symlink "$DOTFILES_DIR/home/.vimrc" "$HOME/.vimrc"
fi

if [ -f "$DOTFILES_DIR/home/.tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/home/.tmux.conf" "$HOME/.tmux.conf"
fi

# Post-installation setup
post_install_setup() {
    echo "🔧 Running post-installation setup..."
    
    # Add Fish to /etc/shells if not already there
    if command_exists fish; then
        local fish_path
        fish_path="$(command -v fish)"
        
        if ! grep -q "$fish_path" /etc/shells 2>/dev/null; then
            echo "🐟 Adding Fish to /etc/shells..."
            echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
        fi
        
        # Offer to change default shell to Fish
        if [ "$SHELL" != "$fish_path" ]; then
            echo "🐟 Would you like to change your default shell to Fish? (y/n)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                chsh -s "$fish_path"
                echo "✅ Default shell changed to Fish. Please log out and back in for changes to take effect."
            fi
        fi
    fi
    
    # Set up Fish config directory permissions
    if [ -d "$HOME/.config/fish" ]; then
        chmod -R 755 "$HOME/.config/fish"
    fi
    
    # GNOME Settings Restoration
    if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
        echo "📱 GNOME desktop detected!"
        if [ -f "$DOTFILES_DIR/gnome/gnome-settings.dconf" ]; then
            echo "🔄 GNOME settings backup found. Would you like to restore your GNOME settings?"
            echo "This will restore your desktop preferences, themes, keybindings, and extensions."
            read -p "Restore GNOME settings? (y/n): " -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                echo "📱 Restoring GNOME settings..."
                cd "$DOTFILES_DIR/gnome" && ./restore-gnome-settings.sh
            fi
        else
            echo "ℹ️  No GNOME settings backup found. You can create one later with:"
            echo "   cd ~/.dotfiles/gnome && ./backup-gnome-settings.sh"
        fi
    fi
    
    # Nerd Fonts Installation
    if [ -f "$DOTFILES_DIR/fonts/install-nerd-fonts.sh" ]; then
        echo "🔤 Nerd Fonts installation available!"
        echo "Would you like to install Nerd Fonts for better terminal and editor experience?"
        echo "This includes: FiraCode, JetBrainsMono, Hack, Source Code Pro, Meslo, and CascadiaCode"
        read -p "Install Nerd Fonts? (y/n): " -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "🔤 Installing Nerd Fonts..."
            cd "$DOTFILES_DIR/fonts" && ./install-nerd-fonts.sh
        fi
    fi
}

# Run post-installation setup
post_install_setup

echo ""
echo "✅ Dotfiles installation complete!"
echo "🔄 You may need to restart your shell or run 'exec \$SHELL' to apply changes."
echo ""
echo "🔧 What's been installed:"
echo "  • Fish shell with custom configuration"
echo "  • Ghostty terminal emulator with custom config"
echo "  • Oh My Posh with bubblesline theme"
echo "  • GitHub CLI for dotfiles sync"
echo "  • Cron service for automated sync"
echo "  • Git configuration and aliases"
echo "  • Neovim with LazyVim and Rust support"
echo "  • Vim configuration"
echo "  • Tmux configuration"
echo "  • Custom Fish functions and aliases"
echo "  • Desktop notifications for sync feedback"
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
    echo "  • GNOME settings backup/restore system"
fi
if [ -f "$DOTFILES_DIR/fonts/install-nerd-fonts.sh" ]; then
    echo "  • Nerd Fonts installation system"
fi
echo ""
echo "🚀 Quick start:"
echo "  • Run 'fish' to start Fish shell"
echo "  • Try 'posh-theme' to switch Oh My Posh themes"
echo "  • Use 'media20', 'media21', etc. to navigate to mounted drives"
echo "  • Git shortcuts: 'g' (git), 'ga' (add), 'gc' (commit), 'gp' (push)"
