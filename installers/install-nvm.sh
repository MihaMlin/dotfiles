#!/usr/bin/env bash
#
# Install nvm (Node Version Manager)

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing NVM (Node Version Manager)..."

# Check if NVM is already installed
if [ -d "$HOME/.nvm" ]; then
    warning "NVM already installed at $HOME/.nvm"
else
    # Install NVM via official script (https://github.com/nvm-sh/nvm)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    success "NVM installed successfully!"
fi
