# Dotfiles

Personal configuration files for my development environment.

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

## Oh My Posh

This configuration includes Oh My Posh with a custom bubblesline theme that shows:
- Current path with folder icon
- Git branch information
- Programming language versions (Python, Go, Node, Ruby, Java, Julia, Rust)
- Battery status
- User session info

### Usage

```bash
# Switch themes temporarily
posh-theme <theme-name>

# List available themes
posh-theme
```

## Adding New Configurations

1. Move your config file to the appropriate directory in `.dotfiles/`
2. Create a symlink from the original location to the dotfiles location
3. Update the install script if needed
