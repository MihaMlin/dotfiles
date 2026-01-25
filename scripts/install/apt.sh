#!/usr/bin/env bash
#
# Install system packages via apt from a file

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Updating apt and installing system packages..."

sudo apt update
sudo apt upgrade -y

# Read packages, skip comments and empty lines
packages=()
packages_path="scripts/apt-packages.txt"
while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && [[ ! "$pkg" =~ ^# ]]&& packages+=("$pkg")
done < "$packages_path"

# Install packages
if [[ ${#packages[@]} -gt 0 ]]; then
    sudo apt install -y "${packages[@]}"
    sudo apt autoremove -y
    sudo apt clean
    success "${#packages[@]} packages installed"
else
    warning "No packages found"
fi

success "Apt installation complete."
