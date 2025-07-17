# Fish shell configuration

# Set environment variables
set -gx EDITOR nano
set -gx PAGER less
set -gx LANG en_US.UTF-8
set -gx QT_QPA_PLATFORMTHEME kvantum

# Add local bin to PATH
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Aliases
alias ll 'ls -alF'
alias la 'ls -A'
alias l 'ls -CF'
alias grep 'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'

# Git aliases
alias g 'git'
alias ga 'git add'
alias gaa 'git add --all'
alias gc 'git commit'
alias gca 'git commit -a'
alias gcm 'git commit -m'
alias gco 'git checkout'
alias gd 'git diff'
alias gl 'git log --oneline --graph --decorate'
alias gp 'git push'
alias gpl 'git pull'
alias gs 'git status'

# System aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'

# Media mount shortcuts
alias media='cd /mnt && ls -la'
alias media20='cd "/mnt/Media 2.0"'
alias media21='cd "/mnt/Media 2.1"'
alias media22='cd "/mnt/Media 2.2"'
alias media23='cd "/mnt/Media 2.3"'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'

# Dotfiles management
alias dotfiles-status='~/.dotfiles/scripts/sync-status.sh'
alias dotfiles-sync='~/.dotfiles/scripts/auto-sync.sh'

# Cargo shortcuts
alias cc='cargo check'
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'

# Load custom functions (fish automatically loads functions from functions/ directory)
# No need to manually source them

# Oh My Posh initialization
if status is-interactive
    oh-my-posh init fish --config ~/.config/oh-my-posh/bubblesline.omp.json | source
end

# Welcome message
if status is-interactive
    echo "🐟 Welcome to Fish shell!"
    echo "💾 Media drives mounted at /mnt/Media 2.x"
end
set -x GNOME_KEYRING_CONTROL ""
unset SSH_AUTH_SOCK
# Test comment
