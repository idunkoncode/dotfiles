# Nerd Fonts for Dotfiles

This directory contains scripts and configuration for installing and managing Nerd Fonts across different systems.

## What are Nerd Fonts?

Nerd Fonts are popular developer fonts patched with glyphs (icons) from various icon sets including:
- Font Awesome
- Devicons
- Octicons
- Powerline symbols
- Weather icons
- And many more!

## Scripts

### `install-nerd-fonts.sh`
Installs the most popular Nerd Fonts for development and terminal use:
- **FiraCode Nerd Font** - Excellent for programming with ligatures
- **JetBrainsMono Nerd Font** - Great for IDEs and coding
- **Hack Nerd Font** - Classic terminal font
- **Source Code Pro Nerd Font** - Clean and readable
- **Meslo Nerd Font** - Recommended for Oh My Posh
- **CascadiaCode Nerd Font** - Microsoft's modern terminal font

### `test-nerd-fonts.sh`
Tests if Nerd Fonts are properly installed and displays various glyphs and symbols to verify everything is working correctly.

## Installation

### Automatic Installation
The fonts are automatically installed when you run the main dotfiles installation script on systems that support it.

### Manual Installation
```bash
cd ~/.dotfiles/fonts
./install-nerd-fonts.sh
```

### Testing Installation
```bash
cd ~/.dotfiles/fonts
./test-nerd-fonts.sh
```

## Font Locations

Fonts are installed to:
- **Linux**: `~/.local/share/fonts/`
- **macOS**: `~/Library/Fonts/`

## Configuration Examples

### Terminal Applications

**Ghostty**
```toml
# ~/.config/ghostty/config
font-family = "FiraCode Nerd Font"
font-size = 14
```

**Alacritty**
```yaml
# ~/.config/alacritty/alacritty.yml
font:
  normal:
    family: "Hack Nerd Font"
    style: Regular
  size: 12
```

**Kitty**
```ini
# ~/.config/kitty/kitty.conf
font_family FiraCode Nerd Font
font_size 12
```

### Code Editors

**VSCode**
```json
{
  "editor.fontFamily": "'JetBrainsMono Nerd Font', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14
}
```

**Neovim**
```lua
-- For GUI neovim (neovide, etc.)
vim.o.guifont = "FiraCode Nerd Font:h12"
```

### Shell Prompts

**Oh My Posh**
Nerd Fonts are essential for Oh My Posh themes. Recommended fonts:
- Meslo Nerd Font
- FiraCode Nerd Font
- JetBrainsMono Nerd Font

## Font Recommendations by Use Case

### Programming & IDEs
- **FiraCode Nerd Font** - Best ligatures for code
- **JetBrainsMono Nerd Font** - Optimized for IDEs
- **Source Code Pro Nerd Font** - Clean and professional

### Terminal & CLI
- **Hack Nerd Font** - Classic terminal choice
- **Meslo Nerd Font** - Great for powerline themes
- **CascadiaCode Nerd Font** - Modern Microsoft font

### General Use
- **JetBrainsMono Nerd Font** - Versatile and readable
- **FiraCode Nerd Font** - Good balance of features

## Troubleshooting

### Font Not Showing Up
1. Refresh font cache: `fc-cache -fv`
2. Restart your terminal/application
3. Check installation: `fc-list | grep -i "nerd"`

### Symbols Not Displaying
1. Ensure your terminal supports UTF-8
2. Verify the font is set correctly in your terminal
3. Run the test script to verify symbols

### Missing Ligatures
Make sure ligatures are enabled in your editor settings (mainly for FiraCode and JetBrainsMono).

## Adding More Fonts

To add more Nerd Fonts:
1. Visit [Nerd Fonts Releases](https://github.com/ryanoasis/nerd-fonts/releases)
2. Download the desired font ZIP file
3. Extract TTF/OTF files to `~/.local/share/fonts/`
4. Run `fc-cache -fv` to refresh font cache

## Integration with Dotfiles

The fonts are automatically integrated with:
- Main installation script
- Auto-sync system (font configurations are backed up)
- GNOME settings (font preferences are saved)
- Application configurations

## Cross-Platform Support

The font installation works on:
- Linux distributions (Ubuntu, Fedora, Arch, openSUSE)
- macOS (with Homebrew)
- Windows (manual installation)

## Font Licensing

All Nerd Fonts maintain their original licenses. Most are open source and free to use. Check individual font licenses for commercial use requirements.
