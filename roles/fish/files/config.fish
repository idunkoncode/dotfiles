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

# Aliases
alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -la"
alias tree="lsd --tree"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias ps="procs"
alias top="btop"
alias htop="btop"
alias du="dust"
alias df="duf"

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
    echo "🐟 Welcome to Fish Shell!"
    echo "💻 System: $(uname -srm)"
    if command -v neofetch >/dev/null
        neofetch --ascii_distro opensuse
    end
end
