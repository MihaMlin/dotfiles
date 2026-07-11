#!/usr/bin/env bash
# Install nvm (Node Version Manager) and Node.js versions.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=lib/log.sh
source "$DOTFILES_DIR/lib/log.sh"
# shellcheck source=lib/git-clone.sh
source "$DOTFILES_DIR/lib/git-clone.sh"
# shellcheck source=stow/nvm/.config/nvm/path.zsh
source "$DOTFILES_DIR/stow/nvm/.config/nvm/path.zsh"

# --- Config (edit here) ---
VERSIONS=(
    "v18.20.8"
    "--lts"
)
# --- end config ---

NVM_VERSION="v0.40.3"

info "Installing nvm $NVM_VERSION..."
git_install "https://github.com/nvm-sh/nvm.git" "$NVM_DIR" --branch "$NVM_VERSION" --depth 1

# Make nvm usable in this script — it has no binary, so path.zsh only
# defines a zsh-only lazy-load wrapper; source its runtime directly instead.
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

for version in "${VERSIONS[@]}"; do
    info "Installing Node.js $version..."
    nvm install "$version"
done

success "nvm installed at $NVM_DIR"
