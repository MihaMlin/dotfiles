# NVM — Node Version Manager (lazy-loaded)
export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"

# Bash-safe: installers source this file only for NVM_DIR.
[[ -n "${ZSH_VERSION:-}" ]] || return 0

_load_nvm() {
    unset -f nvm node npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }
