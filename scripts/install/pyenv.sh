#!/usr/bin/env bash
#
# Install pyenv and Python versions listed in environments.txt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/pyenv/.config/pyenv/path.zsh
source "$DOTFILES_DIR/stow/pyenv/.config/pyenv/path.zsh"

info "Installing pyenv..."
git_install https://github.com/pyenv/pyenv.git "$PYENV_ROOT"

# Initialize pyenv for this session so we can call `pyenv install`
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$("$PYENV_ROOT/bin/pyenv" init -)"

env_file="$DOTFILES_DIR/scripts/install/pyenv-environments.txt"
if [[ ! -f "$env_file" ]]; then
    warning "$env_file not found. Skipping Python version installation."
    success "pyenv installed at $PYENV_ROOT"
    exit 0
fi

info "Reading versions from $env_file..."
versions=$(grep -v '^#' "$env_file" | grep -v '^$' | cut -d':' -f2 | sort -u)

for version in $versions; do
    if pyenv versions --bare | grep -q "^${version}$"; then
        info "Python $version already installed."
    else
        info "Installing Python $version..."
        pyenv install "$version"
    fi
done

first_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1 | cut -d':' -f2)
if [[ -n "$first_version" ]]; then
    pyenv global "$first_version"
    info "Global Python set to $first_version"
fi

success "pyenv installed at $PYENV_ROOT"
