#!/usr/bin/env bash
#
# Install nvm (Node Version Manager)

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export NVM_DIR="$XDG_DATA_HOME/nvm"

echo "Installing NVM (Node Version Manager) via curl..."

# Check if NVM is already installed
if [ -d "$NVM_DIR" ]; then
    warning "NVM already installed at $NVM_DIR"
else
    # Create directory and install NVM via official script
    mkdir -p "$NVM_DIR"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

success "Latest NVM installed at $NVM_DIR"

# Install Node.js environments from config/nvm/environments.txt
nvm_environments_file="config/nvm/environments.txt"
if [ -f "$nvm_environments_file" ]; then
    info "Installing Node.js environments from $nvm_environments_file..."

    # Load NVM (already using XDG-compliant NVM_DIR from above)
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    while read -r version; do
        if [[ ! -z "$version" && ! "$version" =~ ^# ]]; then
            info "Installing Node.js version $version..."
            nvm install "$version"
        fi
    done < "$nvm_environments_file"

    success "Node.js environments installed."
else
    warning "$nvm_environments_file not found. Skipping Node.js version installation."
fi
