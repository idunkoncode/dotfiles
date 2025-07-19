# Fish Shell Configuration

# Set default editor
set -gx EDITOR nvim

# Add common paths
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin

# Add Homebrew to PATH if it exists
if test -d /home/linuxbrew/.linuxbrew/bin
    fish_add_path /home/linuxbrew/.linuxbrew/bin
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# Add Cargo bin to PATH
if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

# SSH Agent setup
if not pgrep -x ssh-agent > /dev/null
    ssh-agent -c > ~/.ssh/ssh-agent.fish
end
if test -f ~/.ssh/ssh-agent.fish
    source ~/.ssh/ssh-agent.fish > /dev/null
end

# Initialize oh-my-posh prompt if available (preferred)
if command -v oh-my-posh >/dev/null
    oh-my-posh init fish --config ~/.config/catppuccin_mocha.omp.json | source
else if command -v starship >/dev/null
    # Fallback to starship if oh-my-posh isn't available
    starship init fish | source
end

# Initialize zoxide if available
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# Initialize fzf if available
if command -v fzf >/dev/null
    fzf --fish | source
end

# Modern CLI tool aliases (Fish functions for better integration)
function ls --wraps lsd --description 'List files with lsd'
    lsd $argv
end

function ll --wraps lsd --description 'List files in long format'
    lsd -l $argv
end

function la --wraps lsd --description 'List all files including hidden'
    lsd -la $argv
end

function tree --wraps lsd --description 'Display directory tree'
    lsd --tree $argv
end

function cat --wraps bat --description 'Display file contents with syntax highlighting'
    bat $argv
end

function grep --wraps rg --description 'Search with ripgrep'
    rg $argv
end

function find --wraps fd --description 'Find files with fd'
    fd $argv
end

function ps --wraps procs --description 'Process viewer'
    procs $argv
end

function top --wraps btop --description 'System monitor'
    btop $argv
end

function htop --wraps btop --description 'System monitor (htop replacement)'
    btop $argv
end

function du --wraps dust --description 'Disk usage analyzer'
    dust $argv
end

function df --wraps duf --description 'Disk usage with duf'
    duf $argv
end

# Git aliases
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glg="git log --graph --oneline"

# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias di="docker images"

# Kubernetes aliases
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"

# Custom functions
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function extract
    switch $argv[1]
        case "*.tar.bz2"
            tar -xvjf $argv[1]
        case "*.tar.gz"
            tar -xvzf $argv[1]
        case "*.bz2"
            bunzip2 $argv[1]
        case "*.rar"
            unrar x $argv[1]
        case "*.gz"
            gunzip $argv[1]
        case "*.tar"
            tar -xvf $argv[1]
        case "*.tbz2"
            tar -xvjf $argv[1]
        case "*.tgz"
            tar -xvzf $argv[1]
        case "*.zip"
            unzip $argv[1]
        case "*.Z"
            uncompress $argv[1]
        case "*.7z"
            7z x $argv[1]
        case "*"
            echo "don't know how to extract '$argv[1]'..."
    end
end

# Welcome message
if status is-interactive
    echo "🐟 Welcome to Fish Shell, idunkoncode!"
    echo "💻 System: $(uname -srm)"
    if command -v neofetch >/dev/null
        neofetch --ascii_distro opensuse
    end
end
