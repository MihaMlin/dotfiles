# -----------------------------
# Powerlevel10k Instant Prompt
# -----------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# -----------------------------
# Custom Environment Variables (paths, binaries, etc.)
# -----------------------------
export ZSH="$HOME/.dotfiles"              # shortcut to dotfiles
export PROJECTS="$HOME/Code"              # project folder
export PATH="$HOME/.dotfiles/bin:$PATH"   # custom binaries

# Load environment variables from localrc (kept out of repo)
[[ -a ~/.localrc ]] && source ~/.localrc


# -----------------------------
# Explicit config file loading
# -----------------------------

# 1. Load path management first (from all modules)
path_files=($(find "$ZSH" -name "path.zsh" -type f))
for file in "${path_files[@]}"; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

# 2. Load main config files (explicit list order)
# Aliases for git loaded in plugins.zsh with OMZ snippet
config_files=(
    "$ZSH/zsh/aliases.zsh"      # General aliases
    "$ZSH/zsh/history.zsh"      # History settings
    "$ZSH/zsh/keybindings.zsh"  # Keybindings
    "$ZSH/zsh/plugins.zsh"      # Plugin management (ZInit, OMZ plugins, OMZ aliases/snippets)
    "$ZSH/zsh/integrations.zsh" # Third-party tool integrations
    "$ZSH/zsh/completion.zsh"   # Completion settings
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
