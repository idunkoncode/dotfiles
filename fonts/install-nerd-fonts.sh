#!/bin/bash

# Nerd Font Installation Script
# This script installs popular Nerd Fonts for terminal and editor use

set -e

FONTS_DIR="$HOME/.local/share/fonts"
TEMP_DIR="/tmp/nerd-fonts-install"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Create fonts directory if it doesn't exist
mkdir -p "$FONTS_DIR"
mkdir -p "$TEMP_DIR"

echo "🔤 Installing Nerd Fonts..."

# Function to download and install a Nerd Font
install_nerd_font() {
    local font_name="$1"
    local font_url="$2"
    local font_display_name="$3"
    
    echo "📥 Downloading $font_display_name..."
    
    # Download the font
    if curl -fsSL "$font_url" -o "$TEMP_DIR/$font_name.zip"; then
        echo "📦 Installing $font_display_name..."
        
        # Extract to temporary directory
        unzip -q "$TEMP_DIR/$font_name.zip" -d "$TEMP_DIR/$font_name"
        
        # Install TTF and OTF files
        find "$TEMP_DIR/$font_name" -name "*.ttf" -o -name "*.otf" | while read -r font_file; do
            cp "$font_file" "$FONTS_DIR/"
        done
        
        echo "✅ $font_display_name installed successfully"
    else
        echo "❌ Failed to download $font_display_name"
        return 1
    fi
}

# Popular Nerd Fonts to install
echo "🎯 Installing popular Nerd Fonts..."

# FiraCode Nerd Font (excellent for programming)
install_nerd_font "FiraCode" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" \
    "FiraCode Nerd Font"

# JetBrainsMono Nerd Font (great for IDEs)
install_nerd_font "JetBrainsMono" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    "JetBrainsMono Nerd Font"

# Hack Nerd Font (classic terminal font)
install_nerd_font "Hack" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" \
    "Hack Nerd Font"

# Source Code Pro Nerd Font (clean and readable)
install_nerd_font "SourceCodePro" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.zip" \
    "Source Code Pro Nerd Font"

# Meslo Nerd Font (recommended for Oh My Posh)
install_nerd_font "Meslo" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip" \
    "Meslo Nerd Font"

# CascadiaCode Nerd Font (Microsoft's terminal font)
install_nerd_font "CascadiaCode" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" \
    "CascadiaCode Nerd Font"

# Refresh font cache
echo "🔄 Refreshing font cache..."
fc-cache -fv "$FONTS_DIR" > /dev/null 2>&1

# Clean up temporary files
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Nerd Fonts installation completed!"
echo "📁 Fonts installed to: $FONTS_DIR"
echo ""
echo "🔤 Installed fonts:"
echo "  • FiraCode Nerd Font"
echo "  • JetBrainsMono Nerd Font"
echo "  • Hack Nerd Font"
echo "  • Source Code Pro Nerd Font"
echo "  • Meslo Nerd Font"
echo "  • CascadiaCode Nerd Font"
echo ""
echo "🎨 To use these fonts:"
echo "  • In terminal: Set font to one of the installed Nerd Fonts"
echo "  • In code editor: Choose a Nerd Font in settings"
echo "  • In Ghostty: Add font configuration to ~/.config/ghostty/config"
echo "  • Test with: echo -e '\\ue0b0 \\u00b1 \\ue0a0 \\u27a6 \\u2718 \\u26a1 \\u2699'"
echo ""
echo "💡 Popular choices:"
echo "  • Programming: FiraCode Nerd Font, JetBrainsMono Nerd Font"
echo "  • Terminal: Hack Nerd Font, Meslo Nerd Font"
echo "  • Modern: CascadiaCode Nerd Font"

# Create a font list file
cat > "$SCRIPT_DIR/installed-fonts.txt" << EOF
# Nerd Fonts Installed
# ====================
# Date: $(date)
# Installation: Successful

FiraCode Nerd Font
JetBrainsMono Nerd Font
Hack Nerd Font
Source Code Pro Nerd Font
Meslo Nerd Font
CascadiaCode Nerd Font

# Font Test Characters
# ====================
# Powerline symbols: \ue0b0 \ue0b1 \ue0b2 \ue0b3
# Git symbols: \ue0a0 \ue0a1 \ue0a2 \ue0a3
# File symbols: \uf016 \uf07b \uf07c \uf115
# Development: \ue796 \ue61e \uf419 \uf40a

# To test fonts, run:
# echo -e '\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699'
EOF

echo "📝 Font list saved to: $SCRIPT_DIR/installed-fonts.txt"
