#!/bin/bash

# Wrapper script for running auto-sync from cron with proper environment
# This script sets up the necessary environment variables for GUI notifications

# Set up PATH
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
export PATH

# Set up display and D-Bus for notifications
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Set XDG environment for user session
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Try to find the correct DISPLAY from active sessions
if [ -z "$DISPLAY" ] || [ "$DISPLAY" = ":0" ]; then
    # Check for active X11 sessions
    for display_num in 0 1 2; do
        if [ -S "/tmp/.X11-unix/X${display_num}" ]; then
            export DISPLAY=":${display_num}"
            break
        fi
    done
fi

# Ensure we have a valid D-Bus session
if [ ! -S "$XDG_RUNTIME_DIR/bus" ]; then
    # Try to find D-Bus session from systemd user session
    if command -v systemctl >/dev/null 2>&1; then
        # Get the user session D-Bus address
        dbus_addr=$(systemctl --user show-environment 2>/dev/null | grep DBUS_SESSION_BUS_ADDRESS | cut -d'=' -f2-)
        if [ -n "$dbus_addr" ]; then
            export DBUS_SESSION_BUS_ADDRESS="$dbus_addr"
        fi
    fi
fi

# Change to dotfiles directory
cd /home/shinlevitra/.dotfiles || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Could not change to dotfiles directory" >> /home/shinlevitra/.dotfiles-sync.log
    exit 1
}

# Run the actual auto-sync script
exec ./scripts/auto-sync.sh
