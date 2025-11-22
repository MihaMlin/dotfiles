#!/usr/bin/env bash
#
# Install pyenv

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing pyenv..."

# Check if pyenv is already installed
if [ -d "$HOME/.pyenv" ]; then
    warning "pyenv already installed at $HOME/.pyenv"
else
    # Install pyenv via GitHub
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
    success "pyenv installed successfully!"
fi
