#!/usr/bin/env bash
#
# Install pyenv and Python versions from config.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

info "Starting pyenv installation..."

if [ -d "$PYENV_ROOT" ]; then
    warning "pyenv already exists at $PYENV_ROOT. Updating..."
    git -C "$PYENV_ROOT" pull
else
    info "Cloning pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
fi

# Initialize pyenv for current session
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$("$PYENV_ROOT/bin/pyenv" init -)"

# Install Python versions from config
env_file="$DOTFILES_DIR/config/pyenv/environments.txt"

if [ -f "$env_file" ]; then
    info "Reading versions from $env_file..."

    # Extract unique versions from second column (format: label:version)
    versions=$(grep -v '^#' "$env_file" | grep -v '^$' | cut -d':' -f2 | sort -u)

    for version in $versions; do
        if pyenv versions --bare | grep -q "^${version}$"; then
            info "Python $version already installed."
        else
            info "Installing Python $version..."
            pyenv install "$version"
        fi
    done

    # Set global version from first non-comment line
    first_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1 | cut -d':' -f2)
    if [ -n "$first_version" ]; then
        pyenv global "$first_version"
        success "Global Python set to $first_version"
    fi
else
    error "$env_file not found. Skipping Python version installation."
fi

success "pyenv setup complete!"
