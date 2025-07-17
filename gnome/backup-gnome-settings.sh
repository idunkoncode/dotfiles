#!/bin/bash

# GNOME Settings Backup Script
# This script backs up current GNOME settings to dconf files

set -e

GNOME_DIR="$(dirname "$(readlink -f "$0")")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "📱 Backing up GNOME settings..."

# Check if we're in a GNOME environment
if [ "$XDG_CURRENT_DESKTOP" != "GNOME" ] && [ "$DESKTOP_SESSION" != "gnome" ]; then
    echo "⚠️  Warning: Not running in GNOME environment"
    echo "Current desktop: $XDG_CURRENT_DESKTOP"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create backup directory with timestamp
BACKUP_DIR="$GNOME_DIR/backups/backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Function to backup dconf settings
backup_dconf() {
    local path="$1"
    local filename="$2"
    
    echo "📋 Backing up $path..."
    if dconf dump "$path" > "$BACKUP_DIR/$filename" 2>/dev/null; then
        echo "✅ Saved $filename"
    else
        echo "⚠️  Failed to backup $path"
    fi
}

# Backup main settings
backup_dconf "/" "gnome-settings.dconf"
backup_dconf "/org/gnome/desktop/" "desktop-settings.dconf"
backup_dconf "/org/gnome/shell/" "shell-settings.dconf"
backup_dconf "/org/gnome/settings-daemon/" "settings-daemon.dconf"
backup_dconf "/org/gnome/nautilus/" "nautilus-settings.dconf"
backup_dconf "/org/gnome/mutter/" "mutter-settings.dconf"
backup_dconf "/org/gnome/shell/extensions/" "extensions-settings.dconf"

# Update current settings (overwrite the main files)
echo "🔄 Updating current settings files..."
cp "$BACKUP_DIR"/*.dconf "$GNOME_DIR/" 2>/dev/null || true

# Create extensions list
echo "📦 Creating extensions list..."
gnome-extensions list > "$GNOME_DIR/installed-extensions.txt" 2>/dev/null || echo "No extensions found" > "$GNOME_DIR/installed-extensions.txt"

# Create a summary file
cat > "$GNOME_DIR/backup-info.txt" << EOF
GNOME Settings Backup
====================

Date: $(date)
Hostname: $(hostname)
User: $(whoami)
Desktop: $XDG_CURRENT_DESKTOP
Session: $DESKTOP_SESSION
GNOME Version: $(gnome-shell --version 2>/dev/null || echo "Unknown")

Backup Location: $BACKUP_DIR

Files backed up:
- gnome-settings.dconf (Complete settings)
- desktop-settings.dconf (Desktop preferences)
- shell-settings.dconf (Shell configuration)
- settings-daemon.dconf (Settings daemon)
- nautilus-settings.dconf (File manager)
- mutter-settings.dconf (Window manager)
- extensions-settings.dconf (Extensions)
- installed-extensions.txt (Extensions list)

To restore these settings on another machine:
1. Run: ./restore-gnome-settings.sh
2. Log out and back in
3. Install extensions if needed
EOF

echo ""
echo "✅ GNOME settings backup completed!"
echo "📁 Backup saved to: $BACKUP_DIR"
echo "📋 Current settings updated in: $GNOME_DIR"
echo "📄 Summary: $GNOME_DIR/backup-info.txt"
echo ""
echo "💡 To restore on another machine:"
echo "   cd ~/.dotfiles/gnome && ./restore-gnome-settings.sh"
