#!/usr/bin/env bash
#
# Installer script to install the latest version of Neovim

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

echo "Installing Neovim..."

# Add Neovim PPA
sudo add-apt-repository -y ppa:neovim-ppa/unstable

# Update package list
sudo apt update

# Install Neovim
sudo apt install -y neovim

# Create Neovim config directory and init.lua file
mkdir -p ~/.config/nvim && cp ../../config/neovim/init.lua ~/.config/nvim/init.lua

echo "Neovim installed successfully!"
nvim --version
