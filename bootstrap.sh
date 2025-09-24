#!/bin/bash

# bootstrap.sh - One-step setup for your dev environment
# Make sure script is executable: chmod +x ~/dotfiles/bootstrap.sh

# Clone dotfiles repository if it doesn't exist
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/MihaMlin/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles"

# Setup with GNU Stow
# Check if Stow is installed, install if not
if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow..."
    if command -v apt &> /dev/null; then
        # Debian/Ubuntu
        sudo apt update
        sudo apt install -y stow
    else
        echo "Could not install Stow. Please install it manually."
        exit 1
    fi
fi

# Apply configurations with Stow
echo "Applying configurations with GNU Stow..."
for dir in */; do
    dir=${dir%*/}  # Remove trailing slash
    stow -v "$dir"
done

echo "Setup complete! Your development environment is now configured."
