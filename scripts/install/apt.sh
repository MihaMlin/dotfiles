#!/usr/bin/env bash
#
# Install system packages via apt from a file.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

echo "Updating apt and installing system packages..."

sudo apt update
sudo apt upgrade -y

# Read packages, skip comments and empty lines
packages=()
packages_path="$DOTFILES_DIR/scripts/apt-packages.txt"
while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && [[ ! "$pkg" =~ ^# ]] && packages+=("$pkg")
done < "$packages_path"

if [[ ${#packages[@]} -gt 0 ]]; then
    sudo apt install -y "${packages[@]}"
    sudo apt autoremove -y
    sudo apt clean
    success "${#packages[@]} packages installed"
else
    warning "No packages found in $packages_path"
fi
