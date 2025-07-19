#!/bin/bash

# Fish Shell Uninstall Script

__task "Removing fish config files"
rm -rf "$HOME/.config/fish"
_task_done

__task "Restoring default shell"
if [[ "$SHELL" == */fish ]]; then
    chsh -s /bin/bash
fi
_task_done

__task "Cleaning up fish package (if installed via system)"
if command -v zypper >/dev/null 2>&1; then
    sudo zypper remove -y fish || true
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get remove -y fish || true
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Rs --noconfirm fish || true
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf remove -y fish || true
fi
_task_done

echo "Fish shell has been uninstalled and config cleaned up."
