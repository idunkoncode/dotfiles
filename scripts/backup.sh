#!/bin/bash

# Dotfiles backup script
set -e

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🔄 Creating backup of current dotfiles..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# List of files to backup
declare -a FILES=(
    ".bashrc"
    ".profile"
    ".vimrc"
    ".tmux.conf"
    ".gitconfig"
)

# List of directories to backup
declare -a DIRS=(
    ".config/fish"
    ".config/git"
    ".config/ghostty"
)

# Backup files
for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "📄 Backing up $file"
        cp "$HOME/$file" "$BACKUP_DIR/"
    fi
done

# Backup directories
for dir in "${DIRS[@]}"; do
    if [ -d "$HOME/$dir" ]; then
        echo "📁 Backing up $dir"
        mkdir -p "$BACKUP_DIR/$(dirname "$dir")"
        cp -r "$HOME/$dir" "$BACKUP_DIR/$dir"
    fi
done

echo "✅ Backup completed: $BACKUP_DIR"
