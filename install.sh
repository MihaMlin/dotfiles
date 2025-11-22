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
    step "Running installer scripts..."

    installers=(
        "installers/install-apt.sh"       # Install APT packages first
        "installers/install-nvm.sh"       # Install other tools
        "installers/install-pyenv.sh"
        "installers/install-zinit.sh"
        "installers/set-default-zsh.sh"   # Set ZSH as default shell last
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

    info "Looking for additional installers..."
    for installer in installers/install-*.sh; do
        [[ -f "$installer" ]] && [[ ! " ${installers[@]} " =~ " $installer " ]] &&
            warning "Additional installer found (not executed): $installer"
    done

    # Symlink dotfiles
    step "Setting up dotfiles..."
    if [[ -f "installers/symlink-dotfiles.sh" ]]; then
        bash installers/symlink-dotfiles.sh
    else
        warning "installers/symlink-dotfiles.sh not found"
    fi

    success "Installation complete!"
}

main "$@"
