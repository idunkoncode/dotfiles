#!/bin/bash

# Dotfiles auto-sync script with notifications
# This script checks for changes in the dotfiles directory, commits and pushes them,
# and sends a notification when changes are pushed.

DOTFILES_DIR="/home/shinlevitra/.dotfiles"
LOG_FILE="/home/shinlevitra/.dotfiles-sync.log"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    
    # Try different notification methods based on what's available
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" --icon=dialog-information
    elif command -v zenity >/dev/null 2>&1; then
        zenity --notification --text="$title: $message"
    fi
    
    # Also log the notification
    log "NOTIFICATION: $title - $message"
}

# Change to dotfiles directory
cd "$DOTFILES_DIR" || {
    log "ERROR: Could not change to dotfiles directory: $DOTFILES_DIR"
    exit 1
}

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    log "ERROR: Not in a git repository"
    exit 1
fi

# Fetch latest changes from remote
git fetch origin >/dev/null 2>&1

# Check if there are any local changes (modified, added, or deleted files)
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git status --porcelain)" ]; then
    log "Local changes detected, preparing to sync..."
    
    # Add all changes
    git add . >/dev/null 2>&1
    
    # Check if there are actually changes to commit after staging
    if git diff --cached --quiet; then
        log "No changes to commit after staging"
        exit 0
    fi
    
    # Create commit message with current date
    COMMIT_MSG="Auto-sync dotfiles - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Commit changes
    if git commit -m "$COMMIT_MSG" >/dev/null 2>&1; then
        log "Changes committed: $COMMIT_MSG"
        
        # Push changes
        if git push origin main >/dev/null 2>&1; then
            log "Changes pushed successfully"
            send_notification "Dotfiles Synced" "Your dotfiles have been automatically synced to the repository"
        else
            log "ERROR: Failed to push changes"
            send_notification "Dotfiles Sync Error" "Failed to push changes to repository"
            exit 1
        fi
    else
        log "ERROR: Failed to commit changes"
        send_notification "Dotfiles Sync Error" "Failed to commit local changes"
        exit 1
    fi
else
    log "No local changes detected"
fi

# Check if remote has new changes we need to pull
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    log "Remote changes detected, pulling..."
    if git pull origin main >/dev/null 2>&1; then
        log "Successfully pulled remote changes"
        send_notification "Dotfiles Updated" "Remote dotfiles changes have been pulled"
    else
        log "ERROR: Failed to pull remote changes"
        send_notification "Dotfiles Sync Error" "Failed to pull remote changes"
        exit 1
    fi
fi

log "Sync completed successfully"
