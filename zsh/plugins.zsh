# -----------------------------
# Zinit Plugins
# -----------------------------

# Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ZSH plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# OMZ snippets (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins)
zinit snippet OMZP::git   # git aliases and functions
zinit snippet OMZP::sudo  # double [esc] for sudo prefix on previous command
