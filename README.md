# Dotfiles 🐟

My personal dotfiles and configuration files for a modern, cross-platform development environment.

## ✨ Features

- 🐟 **Fish shell** with custom configuration and functions
- 🎨 **Oh My Posh** with beautiful themes and prompts
- 🔧 **Git** configuration with useful aliases
- 📝 **Vim** configuration
- 🖥️ **Tmux** configuration
- 🚀 **Cross-platform support** (Linux, macOS)
- 📦 **Multi-distribution support** (Ubuntu, Fedora, Arch, openSUSE, etc.)

## 🚀 Quick Installation

### One-liner Bootstrap (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/idunkoncode/dotfiles/master/scripts/bootstrap.sh | bash
```

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/idunkoncode/dotfiles.git ~/.dotfiles
   ```

2. **Run the installation script:**
   ```bash
   cd ~/.dotfiles
   ./scripts/install.sh
   ```

3. **Restart your shell:**
   ```bash
   exec $SHELL
   ```

## Supported Distributions

- **Ubuntu/Debian** (apt)
- **Fedora/RHEL/CentOS** (dnf/yum)
- **Arch Linux/Manjaro** (pacman)
- **openSUSE** (zypper)
- **macOS** (homebrew)

## Structure

```
.dotfiles/
├── config/          # XDG config files
│   ├── fish/        # Fish shell configuration
│   ├── git/         # Git configuration
│   ├── ghostty/     # Ghostty terminal configuration
│   └── oh-my-posh/  # Oh My Posh theme configuration
├── home/            # Home directory dotfiles
│   ├── .bashrc
│   ├── .profile
│   ├── .gitconfig
│   ├── .vimrc
│   └── .tmux.conf
├── scripts/         # Utility scripts
│   ├── install.sh   # Installation script
│   ├── backup.sh    # Backup script
│   ├── sync.sh      # Sync script
│   └── update.sh    # Update script
└── README.md
```

## Installation

```bash
cd ~/.dotfiles
./scripts/install.sh
```

## Manual Setup

If you prefer to set up manually:

```bash
# Create symlinks for config files
ln -sf ~/.dotfiles/config/fish ~/.config/fish
ln -sf ~/.dotfiles/config/git ~/.config/git

# Create symlinks for home directory files
ln -sf ~/.dotfiles/home/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/home/.profile ~/.profile
```

## 📦 What Gets Installed

### Core Tools
- `fish` - Modern shell with better defaults
- `git` - Version control
- `curl` & `wget` - Download utilities
- `vim` - Text editor
- `tmux` - Terminal multiplexer
- `oh-my-posh` - Cross-shell prompt theme engine

### Configurations
- Fish shell with custom aliases and functions
- Git configuration with helpful aliases
- Vim configuration
- Tmux configuration
- Oh My Posh theme setup (bubblesline theme)
- Bash configuration with oh-my-posh support

### Custom Functions
- `posh-theme` - Switch Oh My Posh themes easily
- `backup` - Create timestamped backups
- `extract` - Extract various archive formats
- `mkcd` - Create directory and cd into it
- Media drive shortcuts (`media20`, `media21`, etc.)

## 🎨 Oh My Posh Theme Management

This configuration includes Oh My Posh with a custom bubblesline theme that shows:
- Current path with folder icon
- Git branch information
- Programming language versions (Python, Go, Node, Ruby, Java, Julia, Rust)
- Battery status
- User session info

### Switch Themes

```bash
# List available themes
posh-theme

# Switch to a specific theme
posh-theme powerline
posh-theme agnoster
posh-theme atomic
```

### Popular Themes
- `bubblesline` (default)
- `powerline`
- `agnoster`
- `atomic`
- `night-owl`

## 🐟 Fish Shell Features

### Git Aliases
- `g` → `git`
- `ga` → `git add`
- `gaa` → `git add --all`
- `gc` → `git commit`
- `gcm` → `git commit -m`
- `gco` → `git checkout`
- `gd` → `git diff`
- `gl` → `git log --oneline --graph --decorate`
- `gp` → `git push`
- `gpl` → `git pull`
- `gs` → `git status`

### System Aliases
- `ll` → `ls -alF`
- `la` → `ls -A`
- `..` → `cd ..`
- `...` → `cd ../..`
- `py` → `python3`
- `serve` → `python3 -m http.server`

### Development Shortcuts
- `cc` → `cargo check`
- `cb` → `cargo build`
- `cr` → `cargo run`
- `ct` → `cargo test`

## 🔄 Updating

### Update dotfiles from repository

```bash
cd ~/.dotfiles
./scripts/update.sh
```

This will:
- Pull latest changes from the repository
- Reinstall configurations
- Commit and push any local changes

## 🔧 Customization

### Setting Fish as Default Shell

The installation script will offer to set Fish as your default shell, or you can do it manually:

```bash
sudo chsh -s $(which fish) $USER
```

### Adding New Configurations

1. Move your config file to the appropriate directory in `.dotfiles/`
2. Create a symlink from the original location to the dotfiles location
3. Update the install script if needed

## 🐛 Troubleshooting

### Fish Shell Issues

- If fish doesn't start: `exec fish`
- If configs don't load: `fish --version && fish_config`
- Check configuration: `fish --debug`

### Oh My Posh Issues

- If prompt doesn't show: Check if `oh-my-posh` is in PATH
- Theme not loading: Run `posh-theme` to verify installation
- Colors not working: Ensure terminal supports true color

### Permission Issues

- Make scripts executable: `chmod +x ~/.dotfiles/scripts/*.sh`
- Fix fish config permissions: `chmod -R 755 ~/.config/fish`
