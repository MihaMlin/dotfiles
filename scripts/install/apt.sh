#!/usr/bin/env bash
#
# Install system packages via apt from scripts/apt-packages.txt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Updating apt and upgrading existing packages..."
sudo apt update
sudo apt upgrade -y

packages_file="$DOTFILES_DIR/scripts/install/apt-packages.txt"
packages=()
while IFS= read -r pkg; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    packages+=("$pkg")
done < "$packages_file"

if [[ ${#packages[@]} -eq 0 ]]; then
    warning "No packages found in $packages_file"
    exit 0
fi

info "Installing ${#packages[@]} package(s)..."
sudo apt install -y "${packages[@]}"
sudo apt autoremove -y
sudo apt clean
success "${#packages[@]} packages installed"
