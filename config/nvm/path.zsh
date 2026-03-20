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

# Auto-use .nvmrc ob cd
autoload -U add-zsh-hook
load-nvmrc() {
    if [[ -f ".nvmrc" ]]; then
        _load_nvm          # ← najprej naloži nvm
        nvm use
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc  # ← zaženi tudi ob odprtju terminala
