#!/bin/bash

# Automated dotfiles sync script
# This script automatically commits and pushes changes to your dotfiles repository
# Optimized to only sync when changes are detected and keep only 1 backup

# Removed set -e to allow graceful error handling

# Check if we're in a desktop environment for notifications
SEND_NOTIFICATIONS=false
if command -v notify-send > /dev/null 2>&1 && [ -n "$DISPLAY" ]; then
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
TEMP_DIR="/tmp/dotfiles-sync-$$"

echo "🔍 Checking for changes..."

cd "$DOTFILES_DIR"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository"
    exit 1
fi

# Function to check if there are actual changes to sync
check_for_changes() {
    local has_changes=false
    
    # First, check if there are any uncommitted changes in git
    if ! git diff --quiet || ! git diff --cached --quiet; then
        has_changes=true
        echo "📝 Uncommitted changes detected in git repository"
    fi
    
    # If no git changes, check for file-level changes
    if [ "$has_changes" = false ]; then
        # Create temp directory for comparison
        mkdir -p "$TEMP_DIR"
        
        # Copy current configs to temp directory
        if [ -d ~/.config/fish ]; then
            mkdir -p "$TEMP_DIR/config/fish"
            cp -r ~/.config/fish/* "$TEMP_DIR/config/fish/" 2>/dev/null || true
        fi
        
        if [ -d ~/.config/oh-my-posh ]; then
            mkdir -p "$TEMP_DIR/config/oh-my-posh"
            cp -r ~/.config/oh-my-posh/* "$TEMP_DIR/config/oh-my-posh/" 2>/dev/null || true
        fi
        
        # Copy home directory files (only if they're not symlinks to dotfiles repo)
        copy_if_not_symlink() {
            local source="$1"
            local target="$2"
            
            if [ -f "$source" ]; then
                if [ -L "$source" ]; then
                    local link_target=$(readlink "$source")
                    if [[ "$link_target" == *".dotfiles"* ]]; then
                        return 0  # Skip symlinked files
                    fi
                fi
                mkdir -p "$(dirname "$target")"
                cp "$source" "$target" 2>/dev/null || true
            fi
        }
        
        copy_if_not_symlink ~/.bashrc "$TEMP_DIR/home/.bashrc"
        copy_if_not_symlink ~/.gitconfig "$TEMP_DIR/home/.gitconfig"
        copy_if_not_symlink ~/.vimrc "$TEMP_DIR/home/.vimrc"
        copy_if_not_symlink ~/.tmux.conf "$TEMP_DIR/home/.tmux.conf"
        copy_if_not_symlink ~/.profile "$TEMP_DIR/home/.profile"
        
        # Compare with current dotfiles repository
        if [ -d "$TEMP_DIR/config/fish" ] && [ -d "config/fish" ]; then
            if ! diff -r "$TEMP_DIR/config/fish" "config/fish" > /dev/null 2>&1; then
                has_changes=true
                echo "📝 Changes detected in fish config"
            fi
        fi
        
        if [ -d "$TEMP_DIR/config/oh-my-posh" ] && [ -d "config/oh-my-posh" ]; then
            if ! diff -r "$TEMP_DIR/config/oh-my-posh" "config/oh-my-posh" > /dev/null 2>&1; then
                has_changes=true
                echo "📝 Changes detected in oh-my-posh config"
            fi
        fi
        
        # Check home directory files
        for file in .bashrc .gitconfig .vimrc .tmux.conf .profile; do
            if [ -f "$TEMP_DIR/home/$file" ] && [ -f "home/$file" ]; then
                if ! diff "$TEMP_DIR/home/$file" "home/$file" > /dev/null 2>&1; then
                    has_changes=true
                    echo "📝 Changes detected in $file"
                fi
            elif [ -f "$TEMP_DIR/home/$file" ] && [ ! -f "home/$file" ]; then
                has_changes=true
                echo "📝 New file detected: $file"
            fi
        done
        
        # Clean up temp directory
        rm -rf "$TEMP_DIR"
    fi
    
    if [ "$has_changes" = true ]; then
        echo "🔄 Changes detected, starting sync..."
        return 0
    else
        echo "✅ No changes detected, skipping sync."
        return 1
    fi
}

# Only proceed if there are changes
if ! check_for_changes; then
    exit 0
fi

# Send notification about detected changes
notify "Dotfiles Sync" "Changes detected! Starting sync process..." "sync"

# Function to backup current dotfiles
backup_dotfiles() {
    echo "💾 Creating backup of current dotfiles..."
    
    # Remove all existing backups first
    rm -rf "${BACKUP_DIR}_"*
    
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
    echo "🗑️  Previous backups removed (keeping only 1)"
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
    if git push origin HEAD 2>/dev/null; then
        echo "✅ Changes pushed to repository"
    else
        echo "⚠️  Could not push to repository (authentication may be required)"
        echo "🔑 Please set up GitHub authentication:"
        echo "   - Create a Personal Access Token at: https://github.com/settings/tokens"
        echo "   - Run: git push origin HEAD"
        echo "   - Enter your username and token when prompted"
        return 1
    fi
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
        local changed_files=$(git log -1 --pretty=format:"%s" | grep -o "Changed files: [^"]*" | sed 's/Changed files: //')
        notify "Dotfiles Sync" "✅ Successfully synced and pushed changes\n📁 Files: $changed_files" "software-update-available"
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
