#!/bin/bash

# GNOME Uninstall Script

__task "Resetting GNOME settings to defaults"

# Reset themes to defaults
dconf reset /org/gnome/shell/extensions/user-theme/name || true
dconf reset /org/gnome/desktop/interface/gtk-theme || true
dconf reset /org/gnome/desktop/interface/icon-theme || true
dconf reset /org/gnome/desktop/interface/cursor-theme || true
dconf reset /org/gnome/desktop/interface/color-scheme || true

# Reset wallpaper
dconf reset /org/gnome/desktop/background/picture-uri-dark || true

# Reset custom keybindings
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ || true

_task_done

__task "Removing installed GNOME extensions and themes"
if command -v zypper >/dev/null 2>&1; then
    sudo zypper remove -y gnome-shell-extension-manager gnome-shell-extension-user-theme gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect gnome-shell-extension-blur-my-shell papirus-icon-theme arc-theme numix-gtk-theme || true
fi
_task_done

echo "GNOME settings have been reset to defaults and custom themes removed."
