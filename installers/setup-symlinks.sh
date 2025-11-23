#!/usr/bin/env bash
#
# Symlink dotfiles from the repository to the home directory using stow.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Dotfiles symlinking setting up..."

DOTFILES_DIR="$HOME/.dotfiles"

# Symlink git configuration
info "Symlinking git configuration..."
rm -f "$HOME/.gitconfig"
stow -d "$DOTFILES_DIR" -t "$HOME" git

# Symlink zsh configuration
info "Symlinking zsh configuration..."
rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh"
stow -d "$DOTFILES_DIR" -t "$HOME" --ignore='^(?!\.zshrc$).*' zsh # only .zshrc
stow -d "$DOTFILES_DIR/zsh" -t "$HOME" plugins # plugins folder

success "Dotfiles symlinked successfully"
