# 30-plugins.zsh — Zinit plugin declarations

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
[[ -f "$ZINIT_HOME/zinit.zsh" ]] || return
source "$ZINIT_HOME/zinit.zsh"

# Theme (immediate)
zinit ice depth=1 atload'source "$XDG_CONFIG_HOME/zsh/themes/p10k.zsh"'
zinit light romkatv/powerlevel10k

# Completions
zinit ice wait'0' lucid blockf
zinit light zsh-users/zsh-completions

# Autosuggestions
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting
zinit ice wait'1' lucid atinit'zicompinit -d "$XDG_CACHE_HOME/zsh/zcompdump"; zicdreplay'
zinit light zsh-users/zsh-syntax-highlighting

# FZF-tab
zinit ice wait'1' lucid
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit ice wait'2' lucid; zinit snippet OMZP::git
zinit ice wait'2' lucid; zinit snippet OMZP::sudo
