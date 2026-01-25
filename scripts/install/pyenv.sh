#!/usr/bin/env bash
#
# Install pyenv and pyenv-virtualenv for Python version management

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

# XDG-compliant install path
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

echo "Installing pyenv..."

# 1. Install pyenv
if [ -d "$PYENV_ROOT" ]; then
    warning "pyenv already exists at $PYENV_ROOT. Updating..."
    cd "$PYENV_ROOT" && git pull
else
    info "Cloning pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
fi

# 2. Install pyenv-virtualenv plugin
if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    warning "pyenv-virtualenv already exists. Updating..."
    cd "$PYENV_ROOT/plugins/pyenv-virtualenv" && git pull
else
    info "Installing pyenv-virtualenv plugin..."
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
fi

success "pyenv installation complete at $PYENV_ROOT"

# 3. Install Python versions from environments.txt
env_file="$HOME/.dotfiles/config/pyenv/environments.txt"

export PATH="$PYENV_ROOT/bin:$PATH"
eval "$("$PYENV_ROOT/bin/pyenv" init -)"

if [ -f "$env_file" ]; then
    info "Installing Python versions from $env_file..."

    while read -r version; do
        [[ -z "$version" || "$version" =~ ^# ]] && continue

        if pyenv versions --bare | grep -q "^$version$"; then
            info "Python $version already installed"
        else
            info "Installing Python $version..."
            pyenv install "$version"
        fi
    done < "$env_file"

    # Set first version as global default
    first_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1)
    if [ -n "$first_version" ]; then
        pyenv global "$first_version"
        success "Set Python $first_version as global default"
    fi
else
    warning "$env_file not found. Skipping Python version installation."
fi

success "pyenv setup complete!"
