#!/usr/bin/env bash
# Install uv and Python versions.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../../stow/uv/.config/uv/path.zsh
source "$DOTFILES_DIR/stow/uv/.config/uv/path.zsh"

# --- Config (edit here) ---
VERSIONS=(
    "3.10.13"   # default
    "3.11.7"    # deep_learning
    "3.12.1"    # web_api
)
# --- end config ---

if command -v uv &>/dev/null; then
    info "uv already installed."
else
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

# Make uv callable for the rest of this script, even on first install.
export PATH="$UV_INSTALL_DIR:$PATH"

for version in "${VERSIONS[@]}"; do
    info "Installing Python $version..."
    # uv python install is idempotent (no-ops if already present).
    uv python install "$version"
done

first_version="${VERSIONS[0]}"
uv python install "$first_version" --default
uv python pin --global "$first_version"
info "Global Python set to $first_version"

success "uv installed at $UV_INSTALL_DIR"
