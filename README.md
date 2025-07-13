# Dotfiles

Personal configuration files for my development environment.

## Structure

```
.dotfiles/
├── config/          # XDG config files
│   ├── fish/        # Fish shell configuration
│   ├── git/         # Git configuration
│   └── ghostty/     # Ghostty terminal configuration
├── home/            # Home directory dotfiles
│   ├── .bashrc
│   ├── .profile
│   └── .gitconfig
├── scripts/         # Utility scripts
│   └── install.sh   # Installation script
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

## Adding New Configurations

1. Move your config file to the appropriate directory in `.dotfiles/`
2. Create a symlink from the original location to the dotfiles location
3. Update the install script if needed
