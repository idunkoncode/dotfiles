# Rust Role

This Ansible role installs the Rust programming language toolchain using the most appropriate method for each distribution.

## Supported Distributions

### Package Manager Installation (Recommended)
- **Fedora**: Uses `dnf` to install `rustup`
- **Arch Linux**: Uses `pacman` to install `rustup`
- **openSUSE**: Uses `zypper` to install `rustup`
- **openSUSE Tumbleweed**: Uses `zypper` to install `rustup`

### Universal Installer (rustup.rs)
- **Ubuntu**: Downloads and installs rustup directly
- **Debian**: Downloads and installs rustup directly
- **CentOS**: Downloads and installs rustup directly
- **Red Hat Enterprise Linux**: Downloads and installs rustup directly
- **Rocky Linux**: Downloads and installs rustup directly
- **AlmaLinux**: Downloads and installs rustup directly

### Fallback Support
- **Any Linux Distribution**: Universal installer with automatic package manager detection

## Installation Methods

### Method 1: Package Manager (Preferred)
For distributions that package `rustup` in their repositories, the role uses the system package manager. This provides:
- System integration
- Easy updates through package manager
- Consistent with other system tools

### Method 2: Universal Installer
For distributions where `rustup` isn't packaged or for consistency, the role downloads and runs the official rustup installer from [rustup.rs](https://rustup.rs). This provides:
- Latest version of rustup
- Full toolchain management capabilities
- Cross-platform consistency

## What Gets Installed

1. **rustup**: The Rust toolchain installer and version manager
2. **Rust Stable Toolchain**: The latest stable Rust compiler and tools
3. **cargo**: Rust's package manager and build tool
4. **PATH Integration**: Adds `~/.cargo/bin` to your shell PATH

## Configuration

The role is enabled by default in the dotfiles setup. To disable it, comment out or remove `rust` from the `default_roles` list in `group_vars/all.yml`.

```yaml
default_roles:
  # ... other roles ...
  - rust  # Comment this line to disable
```

## Post-Installation

After installation, you'll have access to:
- `rustc`: The Rust compiler
- `cargo`: Package manager and build tool
- `rustup`: Toolchain manager

### Verify Installation
```bash
# Check Rust version
rustc --version

# Check Cargo version
cargo --version

# Check rustup
rustup --version
```

### Managing Toolchains
```bash
# Update to latest stable
rustup update

# Install beta or nightly
rustup install beta
rustup install nightly

# Set default toolchain
rustup default stable
```

## Shell Integration

The role automatically configures PATH for:
- **Bash**: Adds to `~/.bashrc`
- **Fish**: Adds to `~/.config/fish/config.fish`

For other shells, manually add `~/.cargo/bin` to your PATH:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

## Troubleshooting

### Permission Issues
If you encounter permission issues, ensure the installation directory is writable:
```bash
# Check ownership
ls -la ~/.cargo/

# Fix if needed
sudo chown -R $USER:$USER ~/.cargo/
```

### PATH Not Updated
If `cargo` or `rustc` commands aren't found after installation:
```bash
# Reload your shell configuration
source ~/.bashrc  # or ~/.config/fish/config.fish for fish

# Or restart your terminal
```

### Distribution Not Supported
If your distribution isn't specifically supported, the role will fall back to the universal installer. This should work on any Linux distribution with `curl` available.
