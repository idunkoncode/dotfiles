function posh-theme --description 'Switch Oh My Posh theme'
    # Check if oh-my-posh is installed
    if not command -v oh-my-posh > /dev/null 2>&1
        echo "❌ Oh My Posh is not installed. Please install it first."
        echo "💡 You can install it with: curl -s https://ohmyposh.dev/install.sh | bash -s"
        return 1
    end
    
    if test (count $argv) -eq 0
        echo "Usage: posh-theme <theme-name>"
        if test -d ~/.cache/oh-my-posh/themes/
            echo "🎨 Available themes:"
            ls ~/.cache/oh-my-posh/themes/ | grep '\.omp\.json$' | sed 's/\.omp\.json$//' | sort
        else
            echo "No themes directory found. Please install Oh My Posh first."
        end
        return 1
    end
    
    set theme_name $argv[1]
    set theme_path ~/.cache/oh-my-posh/themes/$theme_name.omp.json
    
    if test -f $theme_path
        oh-my-posh init fish --config $theme_path | source
        echo "✅ Switched to $theme_name theme"
        # Update the symlink for persistence
        ln -sf $theme_path ~/.config/oh-my-posh/current-theme.omp.json
    else
        echo "❌ Theme $theme_name not found"
        echo "💡 Use 'posh-theme' without arguments to see available themes"
        return 1
    end
end
