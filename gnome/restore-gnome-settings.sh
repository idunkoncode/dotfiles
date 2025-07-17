#!/bin/bash

# GNOME Settings Restore Script
# This script restores GNOME settings from dconf files

set -e

GNOME_DIR="$(dirname "$(readlink -f "$0")")"

echo "📱 Restoring GNOME settings..."

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

# Check if settings files exist
if [ ! -f "$GNOME_DIR/gnome-settings.dconf" ]; then
    echo "❌ No GNOME settings backup found!"
    echo "Please run backup-gnome-settings.sh first or check if files exist in:"
    echo "$GNOME_DIR"
    exit 1
fi

# Function to restore dconf settings
restore_dconf() {
    local path="$1"
    local filename="$2"
    
    if [ -f "$GNOME_DIR/$filename" ]; then
        echo "📋 Restoring $path from $filename..."
        if dconf load "$path" < "$GNOME_DIR/$filename" 2>/dev/null; then
            echo "✅ Restored $filename"
        else
            echo "⚠️  Failed to restore $path"
        fi
    else
        echo "⚠️  $filename not found, skipping..."
    fi
}

# Create a backup of current settings before restore
echo "💾 Creating backup of current settings..."
BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CURRENT_BACKUP_DIR="$GNOME_DIR/backups/pre_restore_$BACKUP_TIMESTAMP"
mkdir -p "$CURRENT_BACKUP_DIR"
dconf dump / > "$CURRENT_BACKUP_DIR/current-settings.dconf" 2>/dev/null || true

# Restore settings (order matters!)
echo "🔄 Restoring settings..."

# Restore in order of importance
restore_dconf "/org/gnome/desktop/" "desktop-settings.dconf"
restore_dconf "/org/gnome/mutter/" "mutter-settings.dconf"
restore_dconf "/org/gnome/settings-daemon/" "settings-daemon.dconf"
restore_dconf "/org/gnome/nautilus/" "nautilus-settings.dconf"
restore_dconf "/org/gnome/shell/" "shell-settings.dconf"
restore_dconf "/org/gnome/shell/extensions/" "extensions-settings.dconf"

# Optional: Ask about full restore
echo ""
echo "⚙️  The above restores the main settings. Would you like to restore ALL settings?"
echo "This includes application-specific settings and might affect other apps."
read -p "Restore complete settings backup? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Restoring complete settings..."
    restore_dconf "/" "gnome-settings.dconf"
fi

# Show extensions that might need to be installed
if [ -f "$GNOME_DIR/installed-extensions.txt" ]; then
    echo ""
    echo "📦 Extensions that were installed:"
    echo "================================="
    while read -r extension; do
        if [ -n "$extension" ] && [ "$extension" != "No extensions found" ]; then
            echo "  • $extension"
        fi
    done < "$GNOME_DIR/installed-extensions.txt"
    
    echo ""
    echo "💡 To install missing extensions, you can:"
    echo "   1. Use GNOME Extensions website: https://extensions.gnome.org"
    echo "   2. Use package manager (some extensions)"
    echo "   3. Use gnome-extensions install command"
fi

# Show backup info if available
if [ -f "$GNOME_DIR/backup-info.txt" ]; then
    echo ""
    echo "📄 Backup Information:"
    echo "====================="
    head -10 "$GNOME_DIR/backup-info.txt"
fi

echo ""
echo "✅ GNOME settings restore completed!"
echo "📁 Current settings backed up to: $CURRENT_BACKUP_DIR"
echo ""
echo "🔄 Please log out and back in (or restart GNOME Shell with Alt+F2 → r)"
echo "   to see all changes take effect."
echo ""
echo "💡 If something goes wrong, you can restore your previous settings:"
echo "   dconf load / < $CURRENT_BACKUP_DIR/current-settings.dconf"
