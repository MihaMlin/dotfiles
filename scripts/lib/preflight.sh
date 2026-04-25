#!/usr/bin/env bash
# Preflight dependency checks — source this file, don't run it directly.

preflight_check() {
    local missing=()

    for cmd in curl git; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    # Require sudo access for non-root users
    if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
        missing+=("sudo access (run: sudo -v)")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing prerequisites: ${missing[*]}"
        exit 1
    fi
}
