# Initialize Zinit plugin manager for ZSH
#
# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#manual


export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
if [[ -s "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
fi
