#!/usr/bin/env bash
#
# Installer script to install the latest version of fzf

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing latest fzf via git..."

if [ -d "$HOME/.fzf" ]; then
  echo "ℹ️ fzf repo already exists. Updating..."
  cd ~/.fzf && git pull
else
  echo "ℹ️ Cloning fzf repository..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi

~/.fzf/install --all

echo "✅ Latest fzf installed."
