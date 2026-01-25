#!/usr/bin/env bash
#
# Install pyenv and base Python versions from a 2-column config file

set -e

# Logging helpers
error()   { echo -e "\e[31m❌ $1\e[0m"; }
warning() { echo -e "\e[33m⚠️ $1\e[0m"; }
info()    { echo -e "\e[34mℹ️ $1\e[0m"; }
success() { echo -e "\e[32m✅ $1\e[0m"; }

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

info "Starting pyenv installation..."

# 1. Install pyenv
if [ -d "$PYENV_ROOT" ]; then
    warning "pyenv already exists at $PYENV_ROOT. Updating..."
    git -C "$PYENV_ROOT" pull
else
    info "Cloning pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
fi

# 2. Initialize pyenv for current session
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$("$PYENV_ROOT/bin/pyenv" init -)"

# 3. Process Python versions from config
env_file="$HOME/.dotfiles/config/pyenv/environments.txt"

if [ -f "$env_file" ]; then
    info "Reading versions from $env_file..."

    # Extract unique versions from the second column
    # - grep -v removes comments and empty lines
    # - cut -d':' -f2 gets the version number
    # - sort -u ensures we don't try to install the same version twice
    versions=$(grep -v '^#' "$env_file" | grep -v '^$' | cut -d':' -f2 | sort -u)

    for version in $versions; do
        if pyenv versions --bare | grep -q "^$version$"; then
            info "Python $version is already installed."
        else
            info "Installing Python $version..."
            pyenv install "$version"
        fi
    done

    # 4. Set the Global Version
    # We take the version number from the first non-comment line in the file
    first_line_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1 | cut -d':' -f2)

    if [ -n "$first_line_version" ]; then
        pyenv global "$first_line_version"
        success "Global Python set to $first_line_version"
    fi
else
    error "$env_file not found. Skipping installation."
fi

success "pyenv setup completed!"
