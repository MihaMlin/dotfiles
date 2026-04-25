#!/usr/bin/env bash
#
# Installer for the latest Neovim from the unstable PPA.
# Config (init.lua) is symlinked separately via scripts/symlinks.txt.

set -e

echo "Installing Neovim..."

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

echo "Neovim installed successfully!"
nvim --version
