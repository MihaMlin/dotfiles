#!/usr/bin/env bash
#
# Installer script to install the latest version of fzf
# Command-line fuzzy finder

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
INSTALL_PATH="$XDG_DATA_HOME/fzf"

echo "Installing latest fzf via git..."

if [ -d "$INSTALL_PATH" ]; then
    warning "fzf repo already exists. Updating..."
    cd "$INSTALL_PATH" && git pull && "$INSTALL_PATH/install" --all --xdg
else
    info "Cloning fzf repository..."
    mkdir -p "$XDG_DATA_HOME"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_PATH"
    "$INSTALL_PATH/install" --all --xdg
fi

success "Latest fzf installed at $INSTALL_PATH"
