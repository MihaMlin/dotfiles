# -----------------------------
# External Integrations
# -----------------------------

# FZF integration (XDG-compliant location)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

# Load P10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
