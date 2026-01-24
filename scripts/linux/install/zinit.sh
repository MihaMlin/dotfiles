#!/usr/bin/env bash
#
# Install Zinit plugin manager for ZSH.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

echo "Installing latest zinit via git..."

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ -d "$ZINIT_HOME/.git" ]; then
    warning "Zinit already installed at $ZINIT_HOME. Updating..."
    cd "$ZINIT_HOME" && git pull
else
    info "Cloning Zinit repository..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

success "Latest Zinit installed at $ZINIT_HOME."
