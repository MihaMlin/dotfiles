# Pyenv — Python version manager (lazy-loaded)
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
[[ -d "$PYENV_ROOT/bin" ]]   && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d "$PYENV_ROOT/shims" ]] && export PATH="$PYENV_ROOT/shims:$PATH"

# Bash-safe: installers source this file only for PYENV_ROOT and PATH.
[[ -n "${ZSH_VERSION:-}" ]] || return 0

_load_pyenv() {
    unset -f pyenv python pip
    eval "$(pyenv init -)"

    if pyenv help virtualenv-init >/dev/null 2>&1; then
        eval "$(pyenv virtualenv-init -)"
    fi
}

pyenv()  { _load_pyenv; pyenv  "$@"; }
python() { _load_pyenv; python "$@"; }
pip()    { _load_pyenv; pip    "$@"; }
