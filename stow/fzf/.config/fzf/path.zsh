# fzf — fuzzy finder
export FZF_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fzf"

# Bash-safe: installers only need FZF_DIR; the rest is zsh-only.
[[ -n "${ZSH_VERSION:-}" ]] || return 0
[[ -d "$FZF_DIR/bin" ]]     || return 0  # not installed yet

path=("$FZF_DIR/bin" $path)
source <("$FZF_DIR/bin/fzf" --zsh)
