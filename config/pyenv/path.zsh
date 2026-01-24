# Pyenv (Lazy-loaded)
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# Add pyenv to PATH if it exists
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Lazy load - only init when pyenv is called
_load_pyenv() {
    unfunction pyenv 2>/dev/null
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" 2>/dev/null || true
}

pyenv() { _load_pyenv; pyenv "$@"; }
