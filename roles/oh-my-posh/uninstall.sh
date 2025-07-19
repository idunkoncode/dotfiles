#!/bin/bash

# Oh My Posh Uninstall Script

__task "Removing oh-my-posh config files"
rm -rf "$HOME/.config/*omp.json"
_task_done

__task "Uninstalling oh-my-posh via Homebrew"
if command -v brew >/dev/null 2>&1; then
    brew uninstall oh-my-posh || true
fi
_task_done

echo "Oh My Posh has been uninstalled and config cleaned up."
