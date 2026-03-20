# NVM (Lazy-loaded)
export NVM_ROOT="$XDG_DATA_HOME/nvm"

[[ -d "$NVM_ROOT/versions/node" ]] && \
    export PATH="$NVM_ROOT/versions/node/$(ls -1 $NVM_ROOT/versions/node | tail -1)/bin:$PATH"

_load_nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_ROOT/nvm.sh" ] && source "$NVM_ROOT/nvm.sh"
}

nvm() { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm() { _load_nvm; npm "$@"; }
npx() { _load_nvm; npx "$@"; }
