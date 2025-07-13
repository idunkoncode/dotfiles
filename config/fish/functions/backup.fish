function backup --description 'Create a backup of a file or directory'
    if test (count $argv) -eq 0
        echo "Usage: backup <file_or_directory>"
        return 1
    end
    
    for item in $argv
        if test -e $item
            set backup_name "$item.backup."(date +%Y%m%d_%H%M%S)
            cp -r $item $backup_name
            echo "Backed up '$item' to '$backup_name'"
        else
            echo "'$item' does not exist"
            return 1
        end
    end
end
