# 20-aliases.zsh

# Shell
alias reload!='. ~/.zshrc'
alias cls='clear'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Listing
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -laht'
alias lsize='ls -lahS'

# File operations
alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias psg='ps aux | grep'

# Network
alias myip='curl ifconfig.me'
alias ports='netstat -tulanp'

# APT
alias apt-up='sudo apt update && sudo apt upgrade -y'
alias apt-i='sudo apt install -y'
alias apt-rm='sudo apt remove'
alias apt-search='apt search'

# Pyenv
alias py='python'
alias pyenv-ls='pyenv versions'
alias pyenv-i='pyenv install'
alias pyenv-list='pyenv install --list | grep -E "^\s*3\.(1[0-9]|[0-9])\.[0-9]+$"'
alias pyenv-g='pyenv global'
alias pyenv-s='pyenv shell'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tl='tmux ls'
alias tk='tmux kill-server'

# Quick edits
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias dotfiles='cd "$DOTFILES"'

# History
alias h='history'
alias hg='history | grep'

# Misc
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'
alias week='date +%V'
