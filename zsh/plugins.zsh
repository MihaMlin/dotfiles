# Zinit Plugins

# Theme (immediate)
zinit ice depth=1 atload'source $XDG_CONFIG_HOME/zsh/p10k.zsh'
zinit light romkatv/powerlevel10k

# Completions
zinit ice wait'0' lucid blockf
zinit light zsh-users/zsh-completions

# Autosuggestions - defer binding to reduce startup time
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting - load last, defer more
zinit ice wait'1' lucid atinit'zicompinit -d "$XDG_CACHE_HOME/zsh/zcompdump"; zicdreplay'
zinit light zsh-users/zsh-syntax-highlighting

# FZF-tab (after completions)
zinit ice wait'1' lucid
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit ice wait'2' lucid
zinit snippet OMZP::git

zinit ice wait'2' lucid
zinit snippet OMZP::sudo
