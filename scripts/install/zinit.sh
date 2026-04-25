#!/usr/bin/env bash
#
# Install Zinit plugin manager for Zsh.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

echo "Installing latest zinit via git..."

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ -d "$ZINIT_HOME/.git" ]; then
    warning "Zinit already installed at $ZINIT_HOME. Updating..."
    git -C "$ZINIT_HOME" pull
else
    info "Cloning Zinit repository..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

success "Zinit installed at $ZINIT_HOME."
