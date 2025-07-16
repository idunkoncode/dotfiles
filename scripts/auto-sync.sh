#!/bin/bash

# Automated dotfiles sync script
# This script automatically commits and pushes changes to your dotfiles repository

set -e

# Check if we're in a desktop environment for notifications
SEND_NOTIFICATIONS=false
if command -v notify-send >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
    SEND_NOTIFICATIONS=true
fi

# Function to send notifications
notify() {
    local title="$1"
    local message="$2"
    local icon="${3:-info}"
    
    if [ "$SEND_NOTIFICATIONS" = true ]; then
        notify-send "$title" "$message" --icon="$icon" --app-name="Dotfiles Sync" 2>/dev/null || true
    fi
}

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

echo "🔄 Auto-syncing dotfiles..."

cd "$DOTFILES_DIR"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository"
    exit 1
fi

# Function to backup current dotfiles
backup_dotfiles() {
    echo "💾 Creating backup of current dotfiles..."
    
    # Create backup directory with timestamp
    local backup_timestamp=$(date +%Y%m%d_%H%M%S)
    local current_backup_dir="${BACKUP_DIR}_${backup_timestamp}"
    
    mkdir -p "$current_backup_dir"
    
    # Copy current dotfiles to backup
    cp -r ~/.config/fish "$current_backup_dir/" 2>/dev/null || true
    cp -r ~/.config/oh-my-posh "$current_backup_dir/" 2>/dev/null || true
    cp ~/.bashrc "$current_backup_dir/" 2>/dev/null || true
    cp ~/.gitconfig "$current_backup_dir/" 2>/dev/null || true
    cp ~/.vimrc "$current_backup_dir/" 2>/dev/null || true
    cp ~/.tmux.conf "$current_backup_dir/" 2>/dev/null || true
    cp ~/.profile "$current_backup_dir/" 2>/dev/null || true
    
    echo "✅ Backup created at: $current_backup_dir"
}

# Function to sync current configs to dotfiles repo
sync_configs() {
    echo "🔄 Syncing current configurations to dotfiles..."
    
    # Sync fish configuration
    if [ -d ~/.config/fish ]; then
        cp -r ~/.config/fish/* config/fish/ 2>/dev/null || true
    fi
    
    # Sync oh-my-posh configuration
    if [ -d ~/.config/oh-my-posh ]; then
        cp -r ~/.config/oh-my-posh/* config/oh-my-posh/ 2>/dev/null || true
    fi
    
    # Sync home directory files (only if they're not symlinks to dotfiles repo)
    sync_file() {
        local source="$1"
        local target="$2"
        
        if [ -f "$source" ]; then
            # Check if source is a symlink pointing to our dotfiles repo
            if [ -L "$source" ]; then
                local link_target=$(readlink "$source")
                if [[ "$link_target" == *".dotfiles"* ]]; then
                    echo "⚠️  Skipping $source (already symlinked to dotfiles repo)"
                    return 0
                fi
            fi
            
            # Copy the file
            cp "$source" "$target" 2>/dev/null || echo "⚠️  Could not copy $source to $target"
        fi
    }
    
    sync_file ~/.bashrc home/.bashrc
    sync_file ~/.gitconfig home/.gitconfig
    sync_file ~/.vimrc home/.vimrc
    sync_file ~/.tmux.conf home/.tmux.conf
    sync_file ~/.profile home/.profile
    
    echo "✅ Configurations synced"
}

# Function to commit and push changes
commit_and_push() {
    echo "📤 Committing and pushing changes..."
    
    # Add all changes
    git add .
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo "✅ No changes to commit"
        return 0
    fi
    
    # Get list of changed files for commit message
    local changed_files=$(git diff --cached --name-only | head -5 | tr '\n' ' ')
    
    # Create commit message
    local commit_msg="Auto-sync dotfiles - $(date '+%Y-%m-%d %H:%M:%S')

Changed files: $changed_files

This is an automated sync from $(hostname)"
    
    # Commit changes
    git commit -m "$commit_msg"
    
    # Push to remote
    git push origin HEAD
    
    echo "✅ Changes pushed to repository"
}

# Function to get default branch
get_default_branch() {
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "master"
}

# Main execution
main() {
    notify "Dotfiles Sync" "Starting automatic sync..." "sync"
    
    # Check if remote exists
    if ! git remote -v | grep -q origin; then
        echo "❌ No remote repository configured"
        notify "Dotfiles Sync" "Error: No remote repository configured" "error"
        exit 1
    fi
    
    # Pull latest changes first
    echo "📥 Pulling latest changes..."
    local default_branch=$(get_default_branch)
    git pull origin "$default_branch" 2>/dev/null || echo "⚠️  Could not pull latest changes"
    
    # Create backup
    backup_dotfiles
    
    # Sync current configurations
    sync_configs
    
    # Commit and push
    if commit_and_push; then
        notify "Dotfiles Sync" "Successfully synced and pushed changes" "software-update-available"
    else
        notify "Dotfiles Sync" "Sync completed but no changes to push" "info"
    fi
    
    echo ""
    echo "✅ Auto-sync completed successfully!"
    echo "🔗 Repository: $(git remote get-url origin)"
    echo "📅 Last sync: $(date)"
}

# Run main function
main "$@"
