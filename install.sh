#!/usr/bin/env bash
#
# Main installation script to run all installers and set up dotfiles.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }
running() { echo "🚀 $1"; }
step()    { echo "📦 $1"; }


echo "Starting dotfiles installation..."

main() {
    # Installer scripts - install and configure tools
    step "Running installer & setup scripts..."

    installers=(
        "scripts/install/apt.sh"        # APT packages first
        "scripts/install/nvm.sh"        # Dev tools
        "scripts/install/pyenv.sh"
        "scripts/install/zinit.sh"
        "scripts/install/fzf.sh"
        "scripts/setup/default-zsh.sh"  # Set ZSH as default shell
        "scripts/setup/symlinks.sh"     # Symlinks last
    )
    counter=1
    for installer in "${installers[@]}"; do
        if [[ -f "$installer" ]]; then
            running "[$counter] Running $installer..."
            bash "$installer"
            ((counter++))
        else
            warning "Installer not found: $installer"
        fi
    done

    success "Installation & Setup complete!"

    # Launch Zsh shell
    if command -v zsh >/dev/null 2>&1; then
        success "Zsh is installed. Launching Zsh shell..."
        exec zsh -l
    else
        warning "Zsh is not installed. Please install Zsh and set it as your default shell manually."
        return
    fi
}

main "$@"
