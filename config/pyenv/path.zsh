# Pyenv (Lazy-loaded)

# Add pyenv to PATH if it exists
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Add pyenv shims to PATH if they exist
[[ -d "$PYENV_ROOT/shims" ]] && export PATH="$PYENV_ROOT/shims:$PATH"

# Lazy load - only init when pyenv is called
_load_pyenv() {
    unfunction pyenv python pip 2>/dev/null

    eval "$(pyenv init -)"
    if pyenv help virtualenv-init >/dev/null 2>&1; then
        eval "$(pyenv virtualenv-init -)"
    fi
}

# Wrappers that trigger loading pyenv when python, pip, or pyenv is called
pyenv()  { _load_pyenv; pyenv "$@"; }
python() { _load_pyenv; python "$@"; }
pip()    { _load_pyenv; pip "$@"; }
