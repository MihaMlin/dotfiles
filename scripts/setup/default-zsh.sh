#!/usr/bin/env bash
#
# Install Zsh and set it as the default shell.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

echo "Installing and configuring Zsh..."

if ! command -v zsh >/dev/null 2>&1; then
    info "Zsh not found. Installing..."
    sudo apt update
    sudo apt install -y zsh
fi

chsh -s "$(command -v zsh)"

success "Zsh installed and set as default shell!"
