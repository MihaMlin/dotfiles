# -----------------------------
# Zinit Plugins
# -----------------------------

# Powerlevel10k theme (load immediately for instant prompt)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Turbo mode: load these plugins asynchronously after prompt
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# OMZ snippets (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins)
zinit ice wait lucid
zinit snippet OMZP::git   # git aliases and functions

zinit ice wait lucid
zinit snippet OMZP::sudo  # double [esc] for sudo prefix on previous command
