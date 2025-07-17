#!/bin/bash

# Nerd Font Testing Script
# This script tests if Nerd Fonts are properly installed and displays test characters

echo "🔤 Nerd Font Test"
echo "=================="
echo ""

# Check if Nerd Fonts are installed
echo "📋 Checking installed Nerd Fonts..."
echo ""

# Function to test if a font is installed
test_font() {
    local font_name="$1"
    if fc-list | grep -qi "$font_name"; then
        echo "✅ $font_name - Installed"
    else
        echo "❌ $font_name - Not found"
    fi
}

# Test popular Nerd Fonts
test_font "FiraCode Nerd Font"
test_font "JetBrainsMono Nerd Font"
test_font "Hack Nerd Font"
test_font "Source Code Pro Nerd Font"
test_font "Meslo Nerd Font"
test_font "CascadiaCode Nerd Font"

echo ""
echo "🎨 Font Symbol Tests"
echo "===================="
echo ""

# Test different categories of symbols
echo "📁 File & Folder Icons:"
echo -e "  Folder: \uf07b  File: \uf016  Document: \uf15c  Code: \uf121"
echo ""

echo "⚡ Development Icons:"
echo -e "  Git: \ue702  Branch: \ue725  Terminal: \uf120  Code: \uf121"
echo ""

echo "📊 Status Icons:"
echo -e "  Success: \uf00c  Error: \uf00d  Warning: \uf071  Info: \uf05a"
echo ""

echo "🔗 Powerline Symbols:"
echo -e "  Arrow: \ue0b0  Inverse: \ue0b1  Flame: \ue0b2  Honeycomb: \ue0b3"
echo ""

echo "🌐 Network & Cloud:"
echo -e "  Download: \uf019  Upload: \uf093  Cloud: \uf0c2  Wifi: \uf1eb"
echo ""

echo "🔧 System Icons:"
echo -e "  Settings: \uf013  Home: \uf015  User: \uf007  Lock: \uf023"
echo ""

echo "📱 Application Icons:"
echo -e "  Editor: \uf044  Terminal: \uf120  Browser: \uf268  Database: \uf1c0"
echo ""

echo "💡 Testing Tips:"
echo "================"
echo "• If you see squares (□) or question marks (?), the font may not be installed"
echo "• Make sure your terminal is using a Nerd Font"
echo "• Some symbols may appear differently depending on the font"
echo "• Test in your code editor and terminal emulator"
echo ""

echo "🎯 Recommended Fonts by Use Case:"
echo "================================="
echo "• Programming/IDE: FiraCode Nerd Font, JetBrainsMono Nerd Font"
echo "• Terminal: Hack Nerd Font, Meslo Nerd Font"
echo "• Modern UI: CascadiaCode Nerd Font"
echo "• Oh My Posh: Meslo Nerd Font"
echo ""

echo "🔧 Configuration Examples:"
echo "=========================="
echo "• Ghostty: font-family = \"FiraCode Nerd Font\""
echo "• VSCode: \"editor.fontFamily\": \"'FiraCode Nerd Font'\""
echo "• Alacritty: font.normal.family = \"Hack Nerd Font\""
echo ""

# Show current terminal font info if available
if command -v fc-match > /dev/null 2>&1; then
    echo "🖥️  Current Terminal Font:"
    echo "  $(fc-match --format='%{family}: %{style}' monospace)"
    echo ""
fi

# List all available Nerd Fonts
echo "📚 All Available Nerd Fonts:"
echo "============================"
fc-list | grep -i "nerd" | cut -d: -f2 | sort -u | head -20

echo ""
echo "✨ Font test completed!"
echo "💡 To install more fonts, run: ~/.dotfiles/fonts/install-nerd-fonts.sh"
