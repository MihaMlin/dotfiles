#!/usr/bin/env bash
# Preflight dependency checks — source this file, don't run it directly.
# Requires log.sh to be sourced first.

preflight_check() {
    local failed=0

    # DOTFILES_DIR must be set and valid
    if [[ ! -d "${DOTFILES_DIR:-}" ]]; then
        error "DOTFILES_DIR not set or not found: '${DOTFILES_DIR:-}'"
        failed=1
    fi

    [[ $failed -eq 0 ]] || exit 1

    # Ensure XDG and .local/bin directories exist
    mkdir -p \
        "$HOME/.config" \
        "$HOME/.local/bin" \
        "$HOME/.local/share" \
        "$HOME/.local/state" \
        "$HOME/.cache"

    success "Preflight OK."
}
