#!/bin/bash

# Setup script for automated dotfiles synchronization
# This script sets up a cron job to automatically sync your dotfiles

set -e

DOTFILES_DIR="$HOME/.dotfiles"
SCRIPT_PATH="$DOTFILES_DIR/scripts/auto-sync.sh"
LOG_FILE="$HOME/.dotfiles-sync.log"

echo "🔧 Setting up automated dotfiles synchronization..."

# Check if auto-sync script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ Auto-sync script not found at $SCRIPT_PATH"
    exit 1
fi

# Make sure the script is executable
chmod +x "$SCRIPT_PATH"

# Function to display current cron jobs
show_current_cron() {
    echo "📋 Current cron jobs:"
    crontab -l 2>/dev/null || echo "No cron jobs found"
    echo ""
}

# Function to add cron job
add_cron_job() {
    local schedule="$1"
    local description="$2"
    
    # Create cron job entry
    local cron_entry="$schedule cd $DOTFILES_DIR && $SCRIPT_PATH >> $LOG_FILE 2>&1"
    
    echo "➕ Adding cron job: $description"
    echo "📅 Schedule: $schedule"
    echo "📝 Command: $cron_entry"
    echo ""
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "$cron_entry") | crontab -
    
    echo "✅ Cron job added successfully!"
}

# Function to remove existing dotfiles sync cron jobs
remove_existing_jobs() {
    echo "🗑️  Removing existing dotfiles sync cron jobs..."
    
    # Remove any existing dotfiles sync jobs
    crontab -l 2>/dev/null | grep -v "auto-sync.sh" | crontab - 2>/dev/null || true
    
    echo "✅ Existing jobs removed"
}

# Function to setup log rotation
setup_log_rotation() {
    echo "📄 Setting up log rotation..."
    
    # Create logrotate configuration
    cat > "/tmp/dotfiles-sync" << EOF
$LOG_FILE {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 $USER $USER
}
EOF
    
    # Move to system logrotate directory (requires sudo)
    if command -v sudo >/dev/null 2>&1; then
        sudo mv "/tmp/dotfiles-sync" "/etc/logrotate.d/dotfiles-sync"
        echo "✅ Log rotation configured"
    else
        echo "⚠️  Could not setup log rotation (sudo not available)"
        rm "/tmp/dotfiles-sync"
    fi
}

# Function to test the auto-sync script
test_auto_sync() {
    echo "🧪 Testing auto-sync script..."
    
    if "$SCRIPT_PATH" --test 2>/dev/null; then
        echo "✅ Auto-sync script test passed"
    else
        echo "⚠️  Auto-sync script test failed, but proceeding anyway"
    fi
}

# Main menu
main() {
    echo "🔄 Automated Dotfiles Sync Setup"
    echo "================================"
    echo ""
    
    show_current_cron
    
    echo "Please choose a sync schedule:"
    echo "1) Every hour"
    echo "2) Every 4 hours"  
    echo "3) Daily at 2 AM"
    echo "4) Daily at login/logout"
    echo "5) Custom schedule"
    echo "6) Remove all sync jobs"
    echo "7) Show current status"
    echo "8) Exit"
    echo ""
    
    read -p "Enter your choice (1-8): " choice
    
    case $choice in
        1)
            remove_existing_jobs
            add_cron_job "0 * * * *" "Every hour"
            ;;
        2)
            remove_existing_jobs
            add_cron_job "0 */4 * * *" "Every 4 hours"
            ;;
        3)
            remove_existing_jobs
            add_cron_job "0 2 * * *" "Daily at 2 AM"
            ;;
        4)
            remove_existing_jobs
            add_cron_job "@reboot" "At system startup"
            # Also add to shell profile for login
            echo "# Auto-sync dotfiles on login" >> ~/.profile
            echo "$SCRIPT_PATH >> $LOG_FILE 2>&1 &" >> ~/.profile
            echo "✅ Added to system startup and login"
            ;;
        5)
            echo "Enter cron schedule (e.g., '0 */6 * * *' for every 6 hours):"
            read -p "Schedule: " custom_schedule
            if [ -n "$custom_schedule" ]; then
                remove_existing_jobs
                add_cron_job "$custom_schedule" "Custom schedule: $custom_schedule"
            else
                echo "❌ Invalid schedule"
            fi
            ;;
        6)
            remove_existing_jobs
            echo "✅ All dotfiles sync jobs removed"
            ;;
        7)
            show_current_cron
            if [ -f "$LOG_FILE" ]; then
                echo "📄 Recent log entries:"
                tail -20 "$LOG_FILE"
            else
                echo "📄 No log file found"
            fi
            ;;
        8)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice"
            ;;
    esac
    
    echo ""
    echo "📊 Final setup:"
    echo "  Script: $SCRIPT_PATH"
    echo "  Log: $LOG_FILE"
    echo "  Status: $(crontab -l 2>/dev/null | grep -c auto-sync.sh) sync job(s) configured"
    echo ""
    echo "💡 Tips:"
    echo "  - Check logs: tail -f $LOG_FILE"
    echo "  - Manual sync: $SCRIPT_PATH"
    echo "  - Modify schedule: crontab -e"
    echo "  - Remove jobs: crontab -r"
}

# Run setup
main "$@"
