#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
STOW_DIR="$DOTFILES_DIR/stow"
echo "Symlinking dotfiles to: $HOME"

# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Starting dotfiles symlinking from $STOW_DIR..."

if ! command -v stow &>/dev/null; then
    info "Installing stow..."
    sudo apt update
    sudo apt install -y stow
fi

# Symlink each package in the stow directory
for pkg_path in "$STOW_DIR"/*/; do
    pkg=$(basename "$pkg_path")
    info "Stowing: $pkg"

    stow --dir="$STOW_DIR" --target="$HOME" --restow --adopt --no-folding --verbose=2 "$pkg" 2>&1 | while read -r line; do
        if [[ $line == *"LINK"* ]]; then
            echo "  🔗 $line"
        fi
    done
done

success "Symlinking complete. Preveri z: ls -la ~"
