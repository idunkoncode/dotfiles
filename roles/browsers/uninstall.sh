#!/bin/bash

# Browsers Uninstall Script

__task "Uninstalling browsers"

if command -v zypper >/dev/null 2>&1; then
    sudo zypper remove -y google-chrome-stable microsoft-edge-stable firefox || true
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get remove -y google-chrome-stable microsoft-edge-stable firefox || true
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Rs --noconfirm google-chrome microsoft-edge-stable-bin firefox || true
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf remove -y google-chrome-stable microsoft-edge-stable firefox || true
fi

_task_done

__task "Removing browser repositories"
if command -v zypper >/dev/null 2>&1; then
    sudo zypper removerepo google-chrome || true
    sudo zypper removerepo microsoft-edge || true
fi
_task_done

__task "Cleaning browser config directories"
rm -rf "$HOME/.config/google-chrome" || true
rm -rf "$HOME/.config/microsoft-edge" || true
rm -rf "$HOME/.mozilla" || true
_task_done

echo "Browsers have been uninstalled and configs cleaned up."
