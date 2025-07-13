#!/bin/bash

# Dotfiles installation script
set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🚀 Installing dotfiles..."

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

echo "✅ Dotfiles installation complete!"
echo "🔄 You may need to restart your shell or run 'source ~/.bashrc' to apply changes."
