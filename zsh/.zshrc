# -----------------------------
# Powerlevel10k Instant Prompt
# -----------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# -----------------------------
# Dotfiles & Project Paths
# -----------------------------
export ZSH="$HOME/.dotfiles"      # shortcut to dotfiles
export PROJECTS="$HOME/Code"      # project folder


# Load environment variables from localrc (kept out of repo)
[[ -a ~/.localrc ]] && source ~/.localrc


# -----------------------------
# Explicit config file loading
# -----------------------------

# 1. Load path management first
paths_folder="$ZSH/zsh/paths"
if [[ -d "$paths_folder" ]]; then
    for file in "$paths_folder"/*.zsh; do
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
fi

# 2. Load main config files (explicit list order)
config_files=(
    "$ZSH/zsh/aliases.zsh"
    "$ZSH/zsh/history.zsh"
    "$ZSH/zsh/keybindings.zsh"
    "$ZSH/zsh/plugins.zsh"
    "$ZSH/zsh/integrations.zsh"
    "$ZSH/zsh/completion.zsh"
)

for file in "${config_files[@]}"; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

# -----------------------------
# Cleanup
# -----------------------------
unset config_files integration_files completion_files paths_folder

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
