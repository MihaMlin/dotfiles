#!/usr/bin/env bash
#
# Main entry point — runs installers and stows configs into $HOME.
# All sub-scripts inherit DOTFILES_DIR from this script's environment.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"
cd "$SCRIPT_DIR"

# shellcheck source=scripts/lib/log.sh
source "$SCRIPT_DIR/scripts/lib/log.sh"
# shellcheck source=scripts/lib/preflight.sh
source "$SCRIPT_DIR/scripts/lib/preflight.sh"

# Installation steps, run in order.
STEPS=(
    "scripts/install/apt.sh"        # APT packages
    "scripts/setup/symlinks.sh"     # Stow symlinks
    "scripts/install/neovim.sh"     # Neovim + plugins
    "scripts/install/nvm.sh"        # Node Version Manager
    "scripts/install/pyenv.sh"      # Python Version Manager
    "scripts/install/zinit.sh"      # Zsh plugin manager
    "scripts/install/fzf.sh"        # Fzf fuzzy finder
    "scripts/setup/default-zsh.sh"  # Default zsh shell
)

ONLY_SYMLINKS=false
SKIP_APT=false


usage() {
    cat <<EOF
Usage: ./install.sh [options]

Options:
  --skip-apt        Skip apt packages step (faster on re-runs)
  --only-symlinks   Re-run stow only (no sudo, no installers)
  -h, --help        Show this help and exit

Examples:
  ./install.sh                  # full install
  ./install.sh --skip-apt       # everything except apt
  ./install.sh --only-symlinks  # just refresh symlinks
EOF
}


parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --only-symlinks) ONLY_SYMLINKS=true ;;
            --skip-apt)      SKIP_APT=true ;;
            -h|--help)       usage; exit 0 ;;
            *)               error "Unknown flag: $1"; usage >&2; exit 1 ;;
        esac
        shift
    done
}


run_step() {
    local idx="$1" script="$2"

    if [[ ! -f "$script" ]]; then
        warning "Script not found: $script"
        return
    fi

    running "[$idx] $script"
    bash "$SCRIPT_DIR/$script"
}


run_installers() {
    local idx=1
    for script in "${STEPS[@]}"; do
        if [[ "$SKIP_APT" == true && "$script" == "scripts/install/apt.sh" ]]; then
            info "Skipping apt.sh (--skip-apt)"
            continue
        fi
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
    parse_args "$@"

    if [[ "$ONLY_SYMLINKS" == true ]]; then
        running "Running symlinks only..."
        bash "$SCRIPT_DIR/scripts/setup/symlinks.sh"
        success "Symlinking done."
        return
    fi

    preflight_check

    step "Running installer & setup scripts..."
    run_installers

    success "Installation & setup complete!"
    launch_zsh
}

main "$@"
