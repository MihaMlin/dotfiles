# NVM — Node Version Manager
export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"

# Bash-safe: installers only need NVM_DIR; the rest is zsh-only.
[[ -n "${ZSH_VERSION:-}" ]] || return 0

_load_nvm() {
    unset -f nvm node npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }

# Load eagerly despite the lazy wrappers above — some tools (e.g. Claude
# Code) invoke node/npm directly without going through an interactive
# shell prompt, so the lazy wrapper would never get a chance to trigger.
_load_nvm
