#!/usr/bin/env bash
#
# Installer script to install the latest version of fzf

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing latest fzf via git..."

if [ -d "$HOME/.fzf" ]; then
    warning "fzf repo already exists. Updating..."
    cd "$HOME/.fzf" && git pull && ~/.fzf/install --all
else
    info "Cloning fzf repository..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    ~/.fzf/install --all
fi

success "Latest fzf installed."
