# -----------------------------
# Aliases
# -----------------------------
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

# Directory operations
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

# Package management (apt)
alias update='sudo apt update'
alias upgrade='sudo apt upgrade -y'
alias install='sudo apt install -y'
alias remove='sudo apt remove'

# Safety nets
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

# Quick edits
alias zshconfig='code ~/.zshrc'
alias ohmyzsh='code ~/.oh-my-zsh'

# History
alias h='history'
alias hg='history | grep'

# Time
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

# Extract any archive
alias extract='tar -zxvf'

# Grep with colors
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Alias for Cursor AI (WSL Remote Mode)
alias cursor='/mnt/c/Users/mlinm/AppData/Local/Programs/cursor/resources/app/bin/cursor'

# Mamba aliases
alias mc="mamba create -n"
alias ma="mamba activate"
alias md="mamba deactivate"
alias mi="mamba install"
alias ml="mamba env list"
alias mr="mamba remove --all -n"
alias mup="mamba install -n base --file $ZSH/mamba/environments.txt" # Update base env from environments.txt

# Quick tmux commands
alias t='tmux'
alias ta='tmux attach' # To go back to your previous session
alias tl='tmux ls'     # To see all running sessions
alias tk='tmux kill-server' # To kill all tmux sessions
