# GNOME Settings Backup & Restore

This directory contains your GNOME desktop environment settings and scripts to backup and restore them across different machines.

## Files Overview

### Settings Files
- `gnome-settings.dconf` - Complete GNOME settings backup
- `desktop-settings.dconf` - Desktop preferences (wallpaper, theme, etc.)
- `shell-settings.dconf` - GNOME Shell configuration
- `settings-daemon.dconf` - Settings daemon configuration  
- `nautilus-settings.dconf` - File manager settings
- `mutter-settings.dconf` - Window manager settings
- `extensions-settings.dconf` - Extensions configuration
- `installed-extensions.txt` - List of installed extensions
- `backup-info.txt` - Backup information and timestamp

### Scripts
- `backup-gnome-settings.sh` - Creates a backup of current GNOME settings
- `restore-gnome-settings.sh` - Restores GNOME settings from backup

## Usage

### Creating a Backup
```bash
cd ~/.dotfiles/gnome
./backup-gnome-settings.sh
```

This will:
- Export all GNOME settings to `.dconf` files
- Create a timestamped backup in `backups/` directory
- Update the current settings files
- Generate a list of installed extensions

### Restoring Settings
```bash
cd ~/.dotfiles/gnome
./restore-gnome-settings.sh
```

This will:
- Create a backup of current settings before restoring
- Restore settings from the `.dconf` files
- Ask if you want to restore complete settings or just main ones
- Show you which extensions were installed

**Note:** After restoring, you'll need to log out and back in (or restart GNOME Shell with `Alt+F2` → `r`) for all changes to take effect.

## Automatic Integration

The GNOME settings are automatically integrated into the main dotfiles installation:

1. When you run `~/.dotfiles/scripts/install.sh` on a GNOME system
2. The script detects if you're using GNOME
3. If GNOME settings backup exists, it offers to restore them
4. The installation process handles everything automatically

## What Gets Backed Up

- **Desktop Preferences**: Wallpaper, theme, fonts, mouse settings
- **Keyboard Shortcuts**: All custom keybindings
- **GNOME Shell**: Panel settings, activities overview, hot corner
- **Window Manager**: Window behavior, workspaces, animations
- **File Manager**: Nautilus preferences, sidebar, view settings
- **Extensions**: All extension settings and configurations
- **Applications**: Default applications, file associations

## Extension Management

The backup includes extension settings, but extensions themselves need to be installed separately. After restoring:

1. Check `installed-extensions.txt` for the list of extensions
2. Install missing extensions via:
   - [GNOME Extensions website](https://extensions.gnome.org)
   - Package manager (for some extensions)
   - `gnome-extensions install` command

## Troubleshooting

### If restoration fails:
```bash
# Check if you're in GNOME
echo $XDG_CURRENT_DESKTOP

# Manual restore of specific settings
dconf load /org/gnome/desktop/ < desktop-settings.dconf
```

### If you want to revert:
The restore script creates a backup before applying changes:
```bash
# Restore your previous settings
dconf load / < backups/pre_restore_TIMESTAMP/current-settings.dconf
```

### Reset to defaults:
```bash
# Reset specific area to defaults
dconf reset -f /org/gnome/desktop/

# Reset everything to defaults (careful!)
dconf reset -f /
```

## Cross-Distribution Compatibility

This backup system works across different Linux distributions as long as they use:
- GNOME desktop environment
- `dconf` for settings storage
- Standard GNOME applications

Tested on:
- Ubuntu/Debian with GNOME
- Fedora with GNOME
- openSUSE with GNOME
- Arch/Manjaro with GNOME

## Integration with Auto-Sync

The GNOME settings are automatically included in your dotfiles auto-sync:
- Settings are backed up when changes are detected
- Changes are committed and pushed to your repository
- You'll get notifications when GNOME settings are synced

## Security Note

The backup includes all GNOME settings, which might contain:
- Saved passwords (in some cases)
- Personal preferences
- Application-specific data

Make sure your dotfiles repository is private if it contains sensitive information.
