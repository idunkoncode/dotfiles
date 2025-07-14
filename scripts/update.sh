#!/bin/bash

# Dotfiles update script
set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "🔄 Updating dotfiles..."

cd "$DOTFILES_DIR"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Run 'git init' first."
    exit 1
fi

# Function to determine the default branch
get_default_branch() {
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "master"
}

# Pull latest changes if remote exists
if git remote -v | grep -q origin; then
    echo "📥 Pulling latest changes from repository..."
    DEFAULT_BRANCH=$(get_default_branch)
    git pull origin "$DEFAULT_BRANCH" 2>/dev/null || git pull origin master 2>/dev/null || echo "⚠️  No remote changes to pull"
    
    # Reinstall dotfiles after pulling updates
    echo "🔗 Reinstalling dotfiles with latest changes..."
    ./scripts/install.sh
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
    echo "📤 Pushing changes to repository..."
    DEFAULT_BRANCH=$(get_default_branch)
    git push origin "$DEFAULT_BRANCH" 2>/dev/null || git push origin master 2>/dev/null || echo "⚠️  Could not push to remote"
fi

echo "✅ Dotfiles update completed!"
echo "🔄 Restart your shell or run 'exec $SHELL' to apply any changes."
