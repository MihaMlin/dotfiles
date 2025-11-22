#!/usr/bin/env bash
#
# Install Zinit plugin manager for ZSH.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME/.git" ]; then
    info "Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    success "Zinit installed at $ZINIT_HOME"
else
    warning "Zinit already installed at $ZINIT_HOME"
fi
