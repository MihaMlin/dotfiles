#!/usr/bin/env bash
#
# Main installation script to run all installers and set up dotfiles.
#
# Usage:
#   ./install.sh                  # Full install
#   ./install.sh --only-symlinks  # Re-run symlinks only (no sudo needed)
#   ./install.sh --skip-apt       # Skip apt packages (faster re-run)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# shellcheck source=scripts/lib/log.sh
source "$SCRIPT_DIR/scripts/lib/log.sh"
# shellcheck source=scripts/lib/preflight.sh
source "$SCRIPT_DIR/scripts/lib/preflight.sh"

ONLY_SYMLINKS=false
SKIP_APT=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --only-symlinks) ONLY_SYMLINKS=true ;;
        --skip-apt)      SKIP_APT=true ;;
        *) error "Unknown flag: $1"; exit 1 ;;
    esac
    shift
done

main() {
    if [[ "$ONLY_SYMLINKS" == true ]]; then
        running "Running symlinks only..."
        bash "$SCRIPT_DIR/scripts/setup/symlinks.sh"
        success "Symlinking done."
        return
    fi

    preflight_check

    step "Running installer & setup scripts..."

    installers=(
        "scripts/install/apt.sh"        # APT packages first
        "scripts/install/neovim.sh"     # Neovim
        "scripts/install/nvm.sh"        # Node
        "scripts/install/pyenv.sh"      # Python
        "scripts/install/zinit.sh"      # Zsh plugin manager
        "scripts/install/fzf.sh"        # Fuzzy finder
        "scripts/setup/default-zsh.sh"  # Set Zsh as default shell
        "scripts/setup/symlinks.sh"     # Symlinks last
    )

    counter=1
    for installer in "${installers[@]}"; do
        if [[ "$SKIP_APT" == true && "$installer" == "scripts/install/apt.sh" ]]; then
            info "Skipping apt.sh (--skip-apt)"
            continue
        fi
        if [[ -f "$installer" ]]; then
            running "[$counter] Running $installer..."
            bash "$SCRIPT_DIR/$installer"
            ((counter++))
        else
            warning "Installer not found: $installer"
        fi
    done

    success "Installation & Setup complete!"

    if command -v zsh >/dev/null 2>&1; then
        success "Launching Zsh shell..."
        exec zsh -l
    else
        warning "Zsh not found. Install it and set it as default shell manually."
    fi
}

main "$@"
