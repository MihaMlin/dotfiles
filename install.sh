#!/usr/bin/env bash
#
# Main entry point — runs installers and stows configs into $HOME.
# All sub-scripts inherit DOTFILES_DIR from this script's environment.
#
# Usage:
#   ./install.sh                  # full install
#   ./install.sh --skip-apt       # everything except apt
#   ./install.sh --only stow      # just refresh symlinks
#   ./install.sh --only nvm       # just (re)run one step

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"
cd "$SCRIPT_DIR"

# shellcheck source=lib/log.sh
source "$SCRIPT_DIR/lib/log.sh"
# shellcheck source=lib/preflight.sh
source "$SCRIPT_DIR/lib/preflight.sh"

# Steps, run in order. Each name is a valid --only argument.
STEP_NAMES=(
    apt
    stow
    nvm
    uv
    zinit
    fzf
    shell
)
STEP_SCRIPTS=(
    scripts/install/apt.sh
    scripts/setup/symlinks.sh
    scripts/install/nvm.sh
    scripts/install/uv.sh
    scripts/install/zinit.sh
    scripts/install/fzf.sh
    scripts/setup/default-zsh.sh
)

ONLY_STEP=""
SKIP_APT=false


usage() {
    cat <<EOF
Usage: ./install.sh [options]

Options:
  --skip-apt     Skip apt packages step (faster on re-runs)
  --only <step>  Run a single step, no sudo unless the step needs it
                 Valid steps: ${STEP_NAMES[*]}
  -h, --help     Show this help and exit

Examples:
  ./install.sh                  # full install
  ./install.sh --skip-apt       # everything except apt
  ./install.sh --only stow      # just refresh symlinks
  ./install.sh --only nvm       # just (re)run the nvm step
EOF
}


parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --only)
                ONLY_STEP="${2:-}"
                [[ -n "$ONLY_STEP" ]] || { error "--only requires a step name"; usage >&2; exit 1; }
                shift
                ;;
            --skip-apt) SKIP_APT=true ;;
            -h|--help)  usage; exit 0 ;;
            *)          error "Unknown flag: $1"; usage >&2; exit 1 ;;
        esac
        shift
    done
}


script_for_step() {
    local step="$1" i
    for i in "${!STEP_NAMES[@]}"; do
        [[ "${STEP_NAMES[$i]}" == "$step" ]] && { echo "${STEP_SCRIPTS[$i]}"; return; }
    done
    error "Unknown step: '$step'. Valid steps: ${STEP_NAMES[*]}"
    exit 1
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


run_only_step() {
    local script
    script=$(script_for_step "$ONLY_STEP")
    run_step "$ONLY_STEP" "$script"
    success "Step '$ONLY_STEP' complete."
}


run_all_steps() {
    local idx=1
    for i in "${!STEP_NAMES[@]}"; do
        if [[ "$SKIP_APT" == true && "${STEP_NAMES[$i]}" == "apt" ]]; then
            info "Skipping apt step (--skip-apt)"
            continue
        fi
        run_step "$idx" "${STEP_SCRIPTS[$i]}"
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

    if [[ -n "$ONLY_STEP" ]]; then
        run_only_step
        return
    fi

    preflight_check

    step "Running installer & setup scripts..."
    run_all_steps

    success "Installation & setup complete!"
    launch_zsh
}

main "$@"
