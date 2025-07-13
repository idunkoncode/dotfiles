function posh-theme --description 'Switch Oh My Posh theme'
    if test (count $argv) -eq 0
        echo "Usage: posh-theme <theme-name>"
        echo "Available themes in ~/.cache/oh-my-posh/themes/:"
        ls ~/.cache/oh-my-posh/themes/ | grep '\.omp\.json$' | sed 's/\.omp\.json$//'
        return 1
    end
    
    set theme_name $argv[1]
    set theme_path ~/.cache/oh-my-posh/themes/$theme_name.omp.json
    
    if test -f $theme_path
        oh-my-posh init fish --config $theme_path | source
        echo "Switched to $theme_name theme"
    else
        echo "Theme $theme_name not found"
        return 1
    end
end
