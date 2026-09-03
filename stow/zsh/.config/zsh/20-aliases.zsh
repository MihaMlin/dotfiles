# 20-aliases.zsh — everyday shell aliases

# Shell
alias reload!='exec zsh'
alias cls='clear'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
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
alias du='du -h --max-depth=1'
alias free='free -h'
alias psg='ps aux | grep'

# Network
alias myip='curl -s ifconfig.me'
alias ports='ss -tulnp'

# APT
alias apt-up='sudo apt update && sudo apt upgrade -y'
alias apt-i='sudo apt install -y'
alias apt-rm='sudo apt remove'
alias apt-search='apt search'

# Claude Code
alias c='claude'

# Herdr
alias h='herdr'
alias ha='herdr session attach'
alias hl='herdr session list'
alias hk='herdr server stop'

# Quick edits
alias zshrc='${EDITOR:-vim} "$ZDOTDIR/.zshrc"'
alias dotfiles='cd "$DOTFILES"'

# History
alias his='history'
alias hisg='history | grep'

# Misc
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'
alias week='date +%V'
