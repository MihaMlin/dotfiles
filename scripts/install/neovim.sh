#!/usr/bin/env bash
#
# Install the latest Neovim from the unstable PPA.
# Config (init.lua) is symlinked separately via stow/nvim/.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Installing Neovim from PPA..."
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

success "Neovim installed: $(nvim --version | head -1)"
