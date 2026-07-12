# .zshenv — sourced on EVERY zsh invocation, including non-interactive ones
# Keep it fast: env vars only, no output, no slow evals

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export BIN_HOME="$HOME/.local/bin"

# Tell zsh to read the rest of its config from the XDG location
# This must live here: .zshenv is the only file zsh always reads from $HOME
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Personal
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Code"
export EDITOR="code --wait"
export VISUAL="code --wait"
export PAGER="less"

# PATH. `typeset -U` must come before the assignment so duplicates get stripped
typeset -U path fpath cdpath
typeset -gx PATH
path=("$BIN_HOME" $path)
