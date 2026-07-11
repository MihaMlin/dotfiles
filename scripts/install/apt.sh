#!/usr/bin/env bash
# Install system packages via apt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

# --- Config (edit here) ---
PACKAGES=(
    # Essentials
    "build-essential"
    "cmake"
    "curl"
    "git"
    "jq"
    "python3"
    "python3-pip"
    "shellcheck"
    "stow"
    "tmux"
    "unzip"
    "vim"
    "wget"
    "zsh"
    # Useful
    "htop"
    "tree"
    "neofetch"
    "inxi"
    "traceroute"
    "nmap"
)
# --- end config ---

info "Updating apt and upgrading existing packages..."
sudo apt update
sudo apt upgrade -y

info "Installing ${#PACKAGES[@]} package(s)..."
sudo apt install -y "${PACKAGES[@]}"
sudo apt autoremove -y
sudo apt clean
success "${#PACKAGES[@]} packages installed"
