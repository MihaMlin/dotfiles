# Powerlevel10k Instant Prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Code"
export PATH="$DOTFILES/bin:$PATH"

[[ -f ~/.localrc ]] && source ~/.localrc

# Load tool configs (nvm, mamba, zinit, etc.)
for file in "$DOTFILES"/config/*/path.zsh(N); do
    source "$file"
done

# Load zsh modules
for file in aliases history keybindings plugins integrations completion; do
    source "$DOTFILES/zsh/$file.zsh"
done

unset file
