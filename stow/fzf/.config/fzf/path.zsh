# fzf — fuzzy finder
export FZF_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/fzf"

# Bash-safe: fzf --zsh is zsh-only
[[ -n "${ZSH_VERSION:-}" ]] || return 0
[[ -d "$FZF_HOME/bin" ]]    || return 0

export PATH="$FZF_HOME/bin:$PATH"
source <("$FZF_HOME/bin/fzf" --zsh)
