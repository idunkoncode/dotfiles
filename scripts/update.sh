#!/bin/bash

# Dotfiles update script
set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "🔄 Updating dotfiles repository..."

cd "$DOTFILES_DIR"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Run 'git init' first."
    exit 1
fi

# Pull latest changes if remote exists
if git remote -v | grep -q origin; then
    echo "📥 Pulling latest changes..."
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "⚠️  No remote changes to pull"
fi

# Add any new files
echo "📄 Adding new files..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✅ No changes to commit"
else
    echo "💾 Committing changes..."
    git commit -m "Update dotfiles - $(date)"
fi

# Push if remote exists
if git remote -v | grep -q origin; then
    echo "📤 Pushing changes..."
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "⚠️  Could not push to remote"
fi

echo "✅ Dotfiles update completed!"
