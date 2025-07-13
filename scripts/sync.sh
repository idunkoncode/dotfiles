#!/bin/bash

# Dotfiles sync script - copies current configs to dotfiles directory
set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "🔄 Syncing current configurations to dotfiles..."

# Function to sync file if it exists and is different
sync_file() {
    local source="$1"
    local target="$2"
    
    if [ -f "$source" ] && [ -f "$target" ]; then
        if ! cmp -s "$source" "$target"; then
            echo "📄 Updating $target"
            cp "$source" "$target"
        fi
    elif [ -f "$source" ]; then
        echo "📄 Adding new file $target"
        mkdir -p "$(dirname "$target")"
        cp "$source" "$target"
    fi
}

# Function to sync directory if it exists and is different
sync_dir() {
    local source="$1"
    local target="$2"
    
    if [ -d "$source" ]; then
        echo "📁 Syncing directory $source"
        mkdir -p "$target"
        rsync -av --delete "$source/" "$target/"
    fi
}

echo "📁 Syncing config files..."

# Sync individual files
sync_file "$HOME/.bashrc" "$DOTFILES_DIR/home/.bashrc"
sync_file "$HOME/.profile" "$DOTFILES_DIR/home/.profile"
sync_file "$HOME/.vimrc" "$DOTFILES_DIR/home/.vimrc"
sync_file "$HOME/.tmux.conf" "$DOTFILES_DIR/home/.tmux.conf"
sync_file "$HOME/.gitconfig" "$DOTFILES_DIR/home/.gitconfig"

# Sync directories
sync_dir "$HOME/.config/fish" "$DOTFILES_DIR/config/fish"
sync_dir "$HOME/.config/git" "$DOTFILES_DIR/config/git"
sync_dir "$HOME/.config/ghostty" "$DOTFILES_DIR/config/ghostty"
sync_dir "$HOME/.config/oh-my-posh" "$DOTFILES_DIR/config/oh-my-posh"

echo "✅ Sync completed!"
echo "💡 Run './scripts/update.sh' to commit changes to git"
