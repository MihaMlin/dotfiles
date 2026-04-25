#!/usr/bin/env bash
#
# Install nvm (Node Version Manager) and Node.js versions from config.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export NVM_DIR="$XDG_DATA_HOME/nvm"

echo "Installing NVM (Node Version Manager) via curl..."

if [ -d "$NVM_DIR" ]; then
    warning "NVM already installed at $NVM_DIR"
else
    mkdir -p "$NVM_DIR"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

success "NVM available at $NVM_DIR"

# Install Node.js versions from config
nvm_versions_file="$DOTFILES_DIR/config/nvm/environments.txt"
if [ -f "$nvm_versions_file" ]; then
    info "Installing Node.js versions from $nvm_versions_file..."

    # Load NVM for this session
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    while read -r version; do
        if [[ -n "$version" && ! "$version" =~ ^# ]]; then
            info "Installing Node.js $version..."
            nvm install "$version"
        fi
    done < "$nvm_versions_file"

    success "Node.js versions installed."
else
    warning "$nvm_versions_file not found. Skipping Node.js version installation."
fi
