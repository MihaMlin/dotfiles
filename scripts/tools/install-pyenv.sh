#!/usr/bin/env bash
#
# Install pyenv

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }


echo "Installing latest pyenv via git..."

# Check if pyenv is already installed
if [ -d "$HOME/.pyenv" ]; then
    warning "pyenv already installed at $HOME/.pyenv. Updating..."
    cd "$HOME/.pyenv" && git pull && cd -
else
    # Install pyenv via GitHub
    info "Cloning pyenv repository..."
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
fi

success "Latest pyenv installed."

# Install Python versions from pyenv/versions.txt
pyenv_versions_file="pyenv/versions.txt"
if [ -f "$pyenv_versions_file" ]; then
    info "Installing Python versions from $pyenv_versions_file..."

    # Load PyEnv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    while read -r version; do
        if [[ ! -z "$version" && ! "$version" =~ ^# ]]; then
            info "Installing Python version $version..."
            pyenv install -s "$version"  # -s skips if already installed
        fi
    done < "$pyenv_versions_file"

    success "Python versions installed."
else
    warning "$pyenv_versions_file not found. Skipping Python version installation."
fi

