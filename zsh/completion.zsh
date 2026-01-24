# -----------------------------
# Autocomplete & Completions
# -----------------------------

# Initialize completion system with caching (rebuild once daily)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C  # Use cached completions
fi

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ":fzf-tab:completion:*" fzf-preview 'ls --color $realpath'

# Refresh cdreplay database
zinit cdreplay -q
