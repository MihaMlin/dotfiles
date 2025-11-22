#!/usr/bin/env bash
#
# Symlink dotfiles from the repository to the home directory using stow.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "dotfiles symlinking setup"
