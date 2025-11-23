# -----------------------------
# Autocomplete & Completions
# -----------------------------

# Initialize completion system
autoload -U compinit && compinit

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ":fzf-tab:completion:*" fzf-preview 'ls --color $realpath'

# OMZ (oh-my-zsh) plugins snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Refresh cdreplay database
zinit cdreplay -q
