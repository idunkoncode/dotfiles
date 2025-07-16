#!/bin/bash

# 45-minute dotfiles sync wrapper
# This script runs every 15 minutes but only syncs every 45 minutes

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
SYNC_SCRIPT="$DOTFILES_DIR/scripts/auto-sync.sh"
TIMESTAMP_FILE="$HOME/.dotfiles-last-sync"
LOG_FILE="$HOME/.dotfiles-sync.log"

# Check if 45 minutes have passed since last sync
check_sync_time() {
    local current_time=$(date +%s)
    local last_sync=0
    
    if [ -f "$TIMESTAMP_FILE" ]; then
        last_sync=$(cat "$TIMESTAMP_FILE")
    fi
    
    local time_diff=$((current_time - last_sync))
    local minutes_diff=$((time_diff / 60))
    
    # If 45 minutes or more have passed, sync
    if [ $minutes_diff -ge 45 ]; then
        return 0  # Time to sync
    else
        local remaining=$((45 - minutes_diff))
        echo "$(date): Next sync in $remaining minutes" >> "$LOG_FILE"
        return 1  # Not time to sync yet
    fi
}

# Main execution
if check_sync_time; then
    echo "$(date): Starting 45-minute sync" >> "$LOG_FILE"
    
    # Run the sync script
    if "$SYNC_SCRIPT" >> "$LOG_FILE" 2>&1; then
        # Update timestamp only if sync was successful
        date +%s > "$TIMESTAMP_FILE"
        echo "$(date): Sync completed successfully" >> "$LOG_FILE"
    else
        echo "$(date): Sync failed" >> "$LOG_FILE"
    fi
else
    # Not time to sync yet, just exit quietly
    exit 0
fi
