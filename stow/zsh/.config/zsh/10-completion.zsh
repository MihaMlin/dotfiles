# 10-completion.zsh — loaded after plugins.zsh initialises compinit via zinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-preview 'ls --color $realpath'
