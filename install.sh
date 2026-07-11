#!/usr/bin/env bash
#
# Main entry point — runs the full install and stows configs into $HOME.
# All sub-scripts inherit DOTFILES_DIR from this script's environment.
# Takes no arguments; for a single step, run its script directly
# (see scripts/install/ and scripts/setup/) or use the Makefile targets.
#
# Usage:
#   ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"
cd "$SCRIPT_DIR"

# shellcheck source=lib/log.sh
source "$SCRIPT_DIR/lib/log.sh"
# shellcheck source=lib/preflight.sh
source "$SCRIPT_DIR/lib/preflight.sh"

# Steps, run in order.
STEPS=(
    scripts/install/apt.sh
    scripts/setup/symlinks.sh
    scripts/install/nvm.sh
    scripts/install/uv.sh
    scripts/install/zinit.sh
    scripts/install/fzf.sh
    scripts/setup/default-zsh.sh
)


run_step() {
    local idx="$1" script="$2"

    if [[ ! -f "$script" ]]; then
        warning "Script not found: $script"
        return
    fi

    running "[$idx] $script"
    bash "$SCRIPT_DIR/$script"
}


run_all_steps() {
    local idx=1
    for script in "${STEPS[@]}"; do
        run_step "$idx" "$script"
        ((idx++))
    done
}


launch_zsh() {
    if command -v zsh &>/dev/null; then
        success "Launching zsh..."
        exec zsh -l
    else
        warning "zsh not found. Install it and set it as default shell manually."
    fi
}


main() {
    if [[ $# -gt 0 ]]; then
        error "install.sh takes no arguments (got: $*)"
        error "For a single step, run its script directly or use a Makefile target (see 'make help')."
        exit 1
    fi

    preflight_check

    step "Running installer & setup scripts..."
    run_all_steps

    success "Installation & setup complete!"
    launch_zsh
}

main "$@"
