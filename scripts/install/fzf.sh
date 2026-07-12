#!/usr/bin/env bash
# Install fzf (fuzzy finder).

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=lib/log.sh
source "$DOTFILES_DIR/lib/log.sh"
# shellcheck source=lib/git-clone.sh
source "$DOTFILES_DIR/lib/git-clone.sh"
# shellcheck source=stow/fzf/.config/fzf/path.zsh
source "$DOTFILES_DIR/stow/fzf/.config/fzf/path.zsh"

info "Installing fzf..."
git_install "https://github.com/junegunn/fzf.git" "$FZF_DIR" --depth 1
"$FZF_DIR/install" --bin   # only install the binary, not shell integration
success "fzf installed at $FZF_DIR"
