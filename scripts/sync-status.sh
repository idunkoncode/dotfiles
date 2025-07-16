#!/bin/bash

# Dotfiles sync status checker
cd ~/.dotfiles

echo "📊 Dotfiles Auto-Sync Status Report"
echo "=================================="
echo ""
echo "📁 Repository: $(git remote get-url origin)"
echo "🔄 Current branch: $(git branch --show-current)"
echo "📅 Last commit: $(git log -1 --format='%ar - %s' 2>/dev/null || echo 'No commits yet')"
echo ""
echo "⏰ Cron Configuration:"
crontab -l | grep -v "^#" | grep -v "^$"
echo ""
echo "📝 Recent sync attempts:"
tail -5 ~/.dotfiles-sync.log 2>/dev/null || echo "No recent logs"
echo ""
echo "🔧 Setup Status:"
echo "✅ Cron service: $(systemctl is-active cron)"
echo "✅ Auto-sync script: $(test -x ~/.dotfiles/scripts/auto-sync.sh && echo 'Executable' || echo 'Not found')"
echo "✅ 45-min wrapper: $(test -x ~/.dotfiles/scripts/sync-45min.sh && echo 'Executable' || echo 'Not found')"
echo ""
if [ -f ~/.dotfiles-last-sync ]; then
    last_sync=$(cat ~/.dotfiles-last-sync)
    current_time=$(date +%s)
    time_diff=$(( (current_time - last_sync) / 60 ))
    next_sync=$(( 45 - (time_diff % 45) ))
    echo "📈 Last sync: $time_diff minutes ago"
    echo "📈 Next sync: in $next_sync minutes"
else
    echo "📈 No sync timestamp found - first sync pending"
fi
echo ""
echo "💡 To manually sync: ~/.dotfiles/scripts/auto-sync.sh"
echo "💡 To check logs: tail -f ~/.dotfiles-sync.log"
