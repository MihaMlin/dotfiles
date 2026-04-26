# .zshrc — entry point

# XDG Base Directory Specification (https://specifications.freedesktop.org/basedir-spec/latest/)
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export BIN_HOME="$HOME/.local/bin"

# Powerlevel10k Instant Prompt (must be near top, before any output)
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Env
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Code"
export EDITOR="vscode --wait"
export VISUAL="vscode --wait"

# WSLg (safe no-op outside WSL)
export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/mnt/wslg/runtime-dir}"
export PULSE_SERVER="${PULSE_SERVER:-unix:/mnt/wslg/PulseServer}"

# PATH
typeset -U path fpath cdpath
path=("$BIN_HOME" $path)
export PATH

# Source all config modules in order
for _f in "$XDG_CONFIG_HOME/zsh/"[0-9][0-9]-*.zsh(N); do
    source "$_f"
done

# Source tool path files (each stow package drops one here)
for _f in "$XDG_CONFIG_HOME"/*/path.zsh(N); do
    source "$_f"
done

unset _f

# Local overrides (machine-specific, not tracked)
[[ -f "$HOME/.localrc" ]] && source "$HOME/.localrc"
