#!/usr/bin/env bash
#
# Install nvm (Node Version Manager)

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing NVM (Node Version Manager) via curl..."

# Check if NVM is already installed
if [ -d "$HOME/.nvm" ]; then
    warning "NVM already installed at $HOME/.nvm"
else
    # Install NVM via official script (https://github.com/nvm-sh/nvm)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

success "Latest NVM installed."

# Install Node.js versions from nvm/versions.txt
nvm_versions_file="nvm/versions.txt"
if [ -f "$nvm_versions_file" ]; then
    info "Installing Node.js versions from $nvm_versions_file..."

    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    while read -r version; do
        if [[ ! -z "$version" && ! "$version" =~ ^# ]]; then
            info "Installing Node.js version $version..."
            nvm install "$version"
        fi
    done < "$nvm_versions_file"

    success "Node.js versions installed."
else
    warning "$nvm_versions_file not found. Skipping Node.js version installation."
fi
