#!/usr/bin/env bash
#
# Install ZSH and set up configuration

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing and configuring ZSH..."

# Install ZSH if not installed
if ! command -v zsh >/dev/null 2>&1; then
    info "ZSH not found. Installing ZSH..."
    sudo apt update
    sudo apt install -y zsh
fi

# Set as default shell
chsh -s $(which zsh)

success "ZSH installed and configured!"
