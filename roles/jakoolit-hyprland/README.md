# JaKooLit Hyprland Role

This Ansible role automates the installation of JaKooLit's Hyprland configurations for various Linux distributions.

## Supported Distributions

- **Fedora**: Uses [Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland.git)
- **Arch Linux**: Uses [Arch-Hyprland](https://github.com/JaKooLit/Arch-Hyprland.git)
- **Ubuntu**: Uses [Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland.git) (branch: 25.04)
- **openSUSE Tumbleweed**: Uses [OpenSuse-Hyprland](https://github.com/JaKooLit/OpenSuse-Hyprland.git)

## Configuration Options

### Basic Configuration
```yaml
# Enable/disable the role
jakoolit_hyprland_install: false  # Set to true to enable

# Automatically run install script after downloading
jakoolit_hyprland_auto_install: false  # Set to true to auto-run installer

# Git protocol to use
jakoolit_hyprland_protocol: 'https'  # Options: 'https' or 'ssh'
```

### Protocol Selection

Choose between HTTPS and SSH protocols for cloning repositories:

- **HTTPS** (default): No authentication required, works everywhere
- **SSH**: Requires SSH key setup, faster for authenticated users

## Usage

### 1. Enable the Role
In your `group_vars/all.yml`, uncomment and enable the role:
```yaml
default_roles:
  # ... other roles ...
  - jakoolit-hyprland  # Uncomment this line
  # ... more roles ...
```

### 2. Configure the Role
Set your preferences in `group_vars/all.yml`:
```yaml
# Enable JaKoolit Hyprland installation
jakoolit_hyprland_install: true

# Choose protocol (https or ssh)
jakoolit_hyprland_protocol: 'https'

# Optional: Auto-run installer (use with caution)
jakoolit_hyprland_auto_install: false
```

### 3. Run the Playbook
```bash
# Install all enabled roles
cd .dotfiles && ansible-playbook main.yml --ask-become-pass

# Install only JaKoolit Hyprland
cd .dotfiles && ansible-playbook main.yml --ask-become-pass --tags jakoolit-hyprland
```

## What It Does

1. **Downloads Repository**: Clones the appropriate JaKooLit Hyprland repository based on your distribution
2. **Sets Permissions**: Makes the install script executable
3. **Displays Instructions**: Shows you where the files were downloaded and how to proceed
4. **Optional Auto-Install**: If enabled, automatically runs the installation script

## Manual Installation

If you prefer manual control, set `jakoolit_hyprland_auto_install: false` (default). The role will:
- Download the repository to your home directory
- Display instructions for manual installation
- You can then run the installer when ready:
  ```bash
  cd ~/OpenSuse-Hyprland  # (or your distro's directory)
  ./install.sh
  ```

## Installation Directories

- **Fedora**: `~/Fedora-Hyprland`
- **Arch Linux**: `~/Arch-Hyprland`
- **Ubuntu**: `~/Ubuntu-Hyprland-25.04`
- **openSUSE**: `~/OpenSuse-Hyprland`

## Security Note

The `jakoolit_hyprland_auto_install` option will automatically run the installation script with sudo privileges. Only enable this if you trust the JaKooLit installation scripts and want fully automated setup.
