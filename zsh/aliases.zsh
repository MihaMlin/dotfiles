# Aliases

# Shell
alias reload!='. ~/.zshrc'  # Reload ZSH configuration (source .zshrc)
alias cls='clear'           # Good 'ol Clear Screen command

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'           # Go to previous directory

# Listing
alias ll='ls -lah'
alias ls='ls --color'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -laht'         # Sort by time
alias lsize='ls -lahS'      # Sort by size

# File operations (safe defaults)
alias mkdir='mkdir -p'
alias rm='rm -i'            # Confirm before delete
alias cp='cp -i'            # Confirm before overwrite
alias mv='mv -i'            # Confirm before overwrite

# System monitoring
alias df='df -h'           # Human readable disk space
alias du='du -h'           # Human readable file sizes
alias free='free -h'       # Human readable memory
alias psg='ps aux | grep'  # Search processes

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
alias zshrc='${EDITOR:-code} ~/.zshrc'
alias dotfiles='cd $DOTFILES'

# History
alias h='history'
alias hg='history | grep'

# Misc
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'
alias week='date +%V'
