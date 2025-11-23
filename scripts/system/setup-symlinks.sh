#!/usr/bin/env bash
#
# Symlink specific dotfiles from the repository to the home directory.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

echo "Dotfiles symlinking setup..."

DOTFILES_DIR="$HOME/.dotfiles"

# Map of source => target
declare -A FILE_MAP=(
    ["zsh/.zshrc"]="$HOME/.zshrc"
    ["tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["zsh/themes/powerlevel10k.zsh"]="$HOME/.p10k.zsh"
    ["git/.gitconfig"]="$HOME/.gitconfig"
    ["vscode/settings.json"]="$HOME/.config/Code/User/settings.json"
    ["vscode/keybindings.json"]="$HOME/.config/Code/User/keybindings.json"
)

for src in "${!FILE_MAP[@]}"; do
    target="${FILE_MAP[$src]}"

    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Remove existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        rm -f "$target"
    fi

    # Create symlink
    ln -s "$DOTFILES_DIR/$src" "$target"
    info "Linked: $DOTFILES_DIR/$src → $target"
done

success "All specified dotfiles symlinked successfully"
