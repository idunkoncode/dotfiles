function extract --description 'Extract various archive formats'
    if test (count $argv) -eq 0
        echo "Usage: extract <archive>"
        return 1
    end
    
    for file in $argv
        if test -f $file
            switch $file
                case '*.tar.bz2'
                    tar xjf $file
                case '*.tar.gz'
                    tar xzf $file
                case '*.bz2'
                    bunzip2 $file
                case '*.rar'
                    unrar x $file
                case '*.gz'
                    gunzip $file
                case '*.tar'
                    tar xf $file
                case '*.tbz2'
                    tar xjf $file
                case '*.tgz'
                    tar xzf $file
                case '*.zip'
                    unzip $file
                case '*.Z'
                    uncompress $file
                case '*.7z'
                    7z x $file
                case '*'
                    echo "Don't know how to extract '$file'"
                    return 1
            end
        else
            echo "'$file' is not a valid file"
            return 1
        end
    end
end
