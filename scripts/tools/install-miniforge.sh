#!/usr/bin/env bash
#
# Install Miniforge (Mamba) and setup ML environments

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

OS_TYPE=$(uname) # Linux or Darwin
ARCH_TYPE=$(uname -m) # x86_64 or aarch64
INSTALL_PATH="$HOME/miniforge3"

echo "Installing Miniforge ($OS_TYPE $ARCH_TYPE)..."

# 1. Download and Install Miniforge
if [ -d "$INSTALL_PATH" ]; then
    warning "Miniforge already exists at $INSTALL_PATH. Updating base system..."
    "$INSTALL_PATH/bin/conda" update -n base -c conda-forge conda -y
else
    info "Downloading Miniforge installer..."
    URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${OS_TYPE}-${ARCH_TYPE}.sh"

    # Use curl to download the installer to a temporary location
    if curl -L "$URL" -o /tmp/miniforge.sh; then
        info "Running installer..."
        # -b: Batch mode (silent), -p: Installation path
        bash /tmp/miniforge.sh -b -p "$INSTALL_PATH"
        rm /tmp/miniforge.sh
    else
        error "Failed to download Miniforge. Please check your internet connection."
        exit 1
    fi
fi

# 2. Initialize Mamba for the current shell session
# This allows the script to use the 'mamba' command immediately
if [ -f "$INSTALL_PATH/etc/profile.d/conda.sh" ]; then
    source "$INSTALL_PATH/etc/profile.d/conda.sh"
    source "$INSTALL_PATH/etc/profile.d/mamba.sh"
fi

success "Miniforge/Mamba installation complete."

# 3. Create/Update environments from file
# Assuming your dotfiles structure: ~/.dotfiles/mamba/environments.txt
env_file="$HOME/.dotfiles/mamba/environments.txt"

if [ -f "$env_file" ]; then
    info "Loading environments from $env_file..."

    while read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Extract the environment name (first word of the line)
        env_name=$(echo "$line" | awk '{print $1}')

        info "Creating/Updating environment: $env_name..."

        # Check if environment already exists
        if mamba env list | grep -q "^$env_name "; then
            info "Environment $env_name already exists. Installing/Updating packages..."
        else
            info "Creating new environment $env_name..."
            mamba create -n "$env_name" python -y
        fi

        # Install the packages defined in that line
        # We remove the first word (the name) to pass the rest as packages
        packages=$(echo "$line" | cut -d' ' -f2-)
        mamba install -n "$env_name" $packages -y

    done < "$env_file"

    success "All environments are ready."
else
    warning "Environment file not found at $env_file. Skipping environment setup."
fi

# Final instructions for the user
echo "---------------------------------------------------"
info "Final step: To enable mamba in your terminal, run:"
echo "  $INSTALL_PATH/bin/mamba init zsh"
info "Then, restart your terminal or run: source ~/.zshrc"
echo "---------------------------------------------------"
