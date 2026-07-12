# .zshrc — interactive shells only

# Powerlevel10k instant prompt. Must stay at the top, before anything prints
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# WSLg — only under actual WSL
if [[ -r /proc/sys/fs/binfmt_misc/WSLInterop || -n $WSL_DISTRO_NAME ]]; then
    export DISPLAY="${DISPLAY:-:0}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/mnt/wslg/runtime-dir}"
    export PULSE_SERVER="${PULSE_SERVER:-unix:/mnt/wslg/PulseServer}"
fi

# Module loading
() {
    local f
    local zdir="${ZDOTDIR:-$HOME/.config/zsh}"

    # path.zsh from each stow package first, so tools (zinit, ...) are on PATH
    # before the numbered modules need them.
    for f in "$XDG_CONFIG_HOME"/*/path.zsh(N-.); do
        source "$f"
    done

    # Then the numbered modules, in order
    for f in "$zdir"/[0-9][0-9]-*.zsh(N-.); do
        source "$f"
    done
}

# Machine-specific, not tracked in git
[[ -r "$HOME/.localrc" ]] && source "$HOME/.localrc"
