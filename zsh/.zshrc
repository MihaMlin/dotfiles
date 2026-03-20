# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest/

export XDG_DATA_HOME="$HOME/.local/share"  # persistent app data (databases, plugins, nvm versions...)
export XDG_CONFIG_HOME="$HOME/.config"     # config files (replaces scattered dotfiles in ~)
export XDG_CACHE_HOME="$HOME/.cache"       # non-essential cached data (safe to delete)
export XDG_STATE_HOME="$HOME/.local/state" # runtime state that persists reboots (logs, history)
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# Powerlevel10k Instant Prompt
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Environment
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Code"

# WSLg Environment Variables
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
export PULSE_SERVER=unix:/mnt/wslg/PulseServer

# Path Configuration
typeset -U path fpath cdpath      # Deduplicate
export PATH="$DOTFILES/bin:$PATH"
export PATH="/home/mlinmiha/.local/bin:$PATH"

# Load Tool Configs
for file in "$DOTFILES"/config/*/path.zsh(N); do
    source "$file"
done

# Load Zsh Modules
for file in aliases history keybindings plugins integrations completion; do
    source "$DOTFILES/zsh/$file.zsh"
done

# Local Overrides
[[ -f ~/.localrc ]] && source ~/.localrc

unset file
