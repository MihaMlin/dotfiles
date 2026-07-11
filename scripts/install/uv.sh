#!/usr/bin/env bash
#
# Install uv and Python versions listed in uv-environments.txt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../../stow/uv/.config/uv/path.zsh
source "$DOTFILES_DIR/stow/uv/.config/uv/path.zsh"

if command -v uv &>/dev/null; then
    info "uv already installed."
else
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

# Make uv callable for the rest of this script, even on first install.
export PATH="$UV_INSTALL_DIR:$PATH"

env_file="$DOTFILES_DIR/scripts/install/uv-environments.txt"
if [[ ! -f "$env_file" ]]; then
    warning "$env_file not found. Skipping Python version installation."
    success "uv installed at $UV_INSTALL_DIR"
    exit 0
fi

info "Reading versions from $env_file..."
versions=$(grep -v '^#' "$env_file" | grep -v '^$' | cut -d':' -f2 | sort -u)

for version in $versions; do
    info "Installing Python $version..."
    # uv python install is idempotent (no-ops if already present) —
    # unlike pyenv.sh, no pre-check is needed here.
    uv python install "$version"
done

first_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1 | cut -d':' -f2)
if [[ -n "$first_version" ]]; then
    uv python install "$first_version" --default
    uv python pin --global "$first_version"
    info "Global Python set to $first_version"
fi

success "uv installed at $UV_INSTALL_DIR"
