#!/usr/bin/env bash
#
# Install Zinit plugin manager for Zsh.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/zinit/.config/zinit/path.zsh
source "$DOTFILES_DIR/stow/zinit/.config/zinit/path.zsh"

info "Installing Zinit..."
git_install https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
success "Zinit installed at $ZINIT_HOME"
