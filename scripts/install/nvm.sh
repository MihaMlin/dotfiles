#!/usr/bin/env bash
# Install nvm (Node Version Manager) and Node.js versions from nvm-environments.txt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/nvm/.config/nvm/path.zsh
source "$DOTFILES_DIR/stow/nvm/.config/nvm/path.zsh"

NVM_VERSION="v0.40.3"

info "Installing nvm $NVM_VERSION..."
git_install "https://github.com/nvm-sh/nvm.git" "$NVM_DIR" --branch "$NVM_VERSION" --depth 1

# Load nvm directly — path.zsh lazy-load je zsh-only
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

env_file="$DOTFILES_DIR/scripts/install/nvm-environments.txt"
if [[ ! -f "$env_file" ]]; then
    warn "$env_file not found. Skipping Node.js environment installation."
    success "nvm installed at $NVM_DIR"
    exit 0
fi

info "Installing Node.js environments from $env_file..."
while read -r environment; do
    [[ -z "$environment" || "$environment" =~ ^# ]] && continue
    info "Installing Node.js $environment..."
    nvm install "$environment"
done < "$env_file"

success "nvm installed at $NVM_DIR"
