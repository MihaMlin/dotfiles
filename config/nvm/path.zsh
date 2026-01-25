# NVM (Lazy-loaded)
export NVM_ROOT="$XDG_DATA_HOME/nvm"

# Add node to PATH if default version exists (for non-interactive scripts)
[[ -d "$NVM_ROOT/versions/node" ]] && \
    export PATH="$NVM_ROOT/versions/node/$(ls -1 $NVM_ROOT/versions/node | tail -1)/bin:$PATH"

# Lazy load NVM - only initialize when nvm/node/npm/npx is called
_load_nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_ROOT/nvm.sh" ] && source "$NVM_ROOT/nvm.sh"
}

nvm() { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm() { _load_nvm; npm "$@"; }
npx() { _load_nvm; npx "$@"; }
