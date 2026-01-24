# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# Powerlevel10k Instant Prompt
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Environment
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Code"

# Path Configuration
typeset -U path fpath cdpath      # Deduplicate
# path=(${path:#/mnt/c/*})          # Remove Windows/WSL paths for speed
export PATH="$DOTFILES/bin:$PATH"

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
