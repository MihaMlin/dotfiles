#!/usr/bin/env bash
#
# Install the latest fzf (fuzzy finder) via git.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
INSTALL_PATH="$XDG_DATA_HOME/fzf"

echo "Installing latest fzf via git..."

if [ -d "$INSTALL_PATH" ]; then
    warning "fzf repo already exists. Updating..."
    git -C "$INSTALL_PATH" pull && "$INSTALL_PATH/install" --all --xdg
else
    info "Cloning fzf repository..."
    mkdir -p "$XDG_DATA_HOME"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_PATH"
    "$INSTALL_PATH/install" --all --xdg
fi

success "fzf installed at $INSTALL_PATH"
