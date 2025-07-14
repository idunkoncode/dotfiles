function dotfiles-auto-sync --description 'Enable or disable automatic dotfiles synchronization'
    switch $argv[1]
        case enable on
            set -Ux DOTFILES_AUTO_SYNC 1
            echo "✅ Dotfiles auto-sync enabled"
            echo "🔄 Dotfiles will sync automatically every 5 minutes when you use the terminal"
            echo "📝 To disable: dotfiles-auto-sync disable"
            
        case disable off
            set -e DOTFILES_AUTO_SYNC
            echo "❌ Dotfiles auto-sync disabled"
            echo "📝 To enable: dotfiles-auto-sync enable"
            
        case status
            if set -q DOTFILES_AUTO_SYNC
                echo "✅ Dotfiles auto-sync is ENABLED"
                echo "🔄 Syncs every 5 minutes during terminal usage"
            else
                echo "❌ Dotfiles auto-sync is DISABLED"
            end
            
        case sync now
            if test -f "$HOME/.dotfiles/scripts/auto-sync.sh"
                echo "🔄 Manually syncing dotfiles..."
                "$HOME/.dotfiles/scripts/auto-sync.sh"
            else
                echo "❌ Auto-sync script not found"
            end
            
        case '*'
            echo "📖 Dotfiles Auto-Sync Control"
            echo "Usage: dotfiles-auto-sync <command>"
            echo ""
            echo "Commands:"
            echo "  enable    - Enable automatic syncing"
            echo "  disable   - Disable automatic syncing"
            echo "  status    - Show current status"
            echo "  sync      - Manually sync now"
            echo ""
            echo "Current status:"
            if set -q DOTFILES_AUTO_SYNC
                echo "  ✅ Auto-sync is ENABLED"
            else
                echo "  ❌ Auto-sync is DISABLED"
            end
            echo ""
            echo "💡 When enabled, dotfiles sync automatically every 5 minutes"
            echo "   while you're using the terminal."
    end
end
