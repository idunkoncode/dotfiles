function auto-sync-hook --description 'Automatically sync dotfiles on certain events'
    # Only run if we're in an interactive session
    if not status is-interactive
        return
    end
    
    # Check if auto-sync is enabled
    if not set -q DOTFILES_AUTO_SYNC
        return
    end
    
    # Don't sync too frequently (minimum 5 minutes between syncs)
    set -l last_sync_file "$HOME/.dotfiles-last-sync"
    set -l current_time (date +%s)
    
    if test -f "$last_sync_file"
        set -l last_sync_time (cat "$last_sync_file")
        set -l time_diff (math "$current_time - $last_sync_time")
        
        # If less than 5 minutes (300 seconds) have passed, skip
        if test $time_diff -lt 300
            return
        end
    end
    
    # Update last sync time
    echo $current_time > "$last_sync_file"
    
    # Run sync in background
    if test -f "$HOME/.dotfiles/scripts/auto-sync.sh"
        nohup "$HOME/.dotfiles/scripts/auto-sync.sh" > /dev/null 2>&1 &
        echo "🔄 Auto-syncing dotfiles in background..."
    end
end

# Enable auto-sync hook on fish_prompt (runs after each command)
function fish_prompt_auto_sync --on-event fish_prompt
    auto-sync-hook
end
