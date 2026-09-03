#!/usr/bin/env bash
# Install herdr (terminal multiplexer).

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=lib/log.sh
source "$DOTFILES_DIR/lib/log.sh"
# shellcheck source=stow/herdr/.config/herdr/path.zsh
source "$DOTFILES_DIR/stow/herdr/.config/herdr/path.zsh"

# The upstream installer is idempotent and always fetches the latest release,
# so running it unconditionally is what makes `make update` pick up new
# versions. It reads HERDR_INSTALL_DIR from the environment.
info "Installing herdr..."
curl -fsSL https://herdr.dev/install.sh | sh

# Make herdr usable in this script — it's a real binary, so prepend its
# directory to PATH (path.zsh only declares HERDR_INSTALL_DIR, no eager work).
export PATH="$HERDR_INSTALL_DIR:$PATH"

success "herdr $(herdr --version) installed at $HERDR_INSTALL_DIR"
