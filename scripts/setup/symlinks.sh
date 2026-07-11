#!/usr/bin/env bash
# Symlink (or remove symlinks for) stow packages into $HOME.
# Usage: symlinks.sh [--delete]

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

STOW_DIR="$DOTFILES_DIR/stow"
STOW_ACTION_ARGS=(--restow --adopt)
ACTION_LABEL="Symlinking"
if [[ "${1:-}" == "--delete" ]]; then
    STOW_ACTION_ARGS=(--delete)
    ACTION_LABEL="Unlinking"
fi

if ! command -v stow &>/dev/null; then
    info "Installing stow..."
    sudo apt update
    sudo apt install -y stow
fi

info "$ACTION_LABEL packages from $STOW_DIR into $HOME..."

for pkg_path in "$STOW_DIR"/*/; do
    pkg=$(basename "$pkg_path")
    info "Processing: $pkg"

    stow --dir="$STOW_DIR" --target="$HOME" "${STOW_ACTION_ARGS[@]}" --no-folding --verbose=2 "$pkg" 2>&1 | while read -r line; do
        if [[ $line == *"LINK"* ]]; then
            echo "  🔗 $line"
        fi
    done
done

success "$ACTION_LABEL complete. Check with: ls -la ~"
