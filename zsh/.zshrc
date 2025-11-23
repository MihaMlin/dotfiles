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
export PATH="$HOME/.dotfiles/bin:$PATH"


# Load environment variables from localrc (kept out of repo)
[[ -a ~/.localrc ]] && source ~/.localrc


# -----------------------------
# Explicit config file loading
# -----------------------------

# 1. Load path management first
path_files=($(find "$ZSH" -name "path.zsh" -type f))
for file in "${path_files[@]}"; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

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
unset path_files config_files

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
