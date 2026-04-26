# Zinit — zsh plugin manager
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Bash-safe: installers source this file only for ZINIT_HOME.
[[ -n "${ZSH_VERSION:-}" ]] || return 0

[[ -s "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"
