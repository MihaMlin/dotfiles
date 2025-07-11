#!/bin/bash
echo "Starting dotfiles setup..."

# Install stow if missing
if ! command -v stow &> /dev/null
then
    echo "Installing stow..."
    sudo apt install -y stow
fi

# Clone repo if not present
if [ ! -d ~/.dotfiles ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
fi

# Run the link script
~/.dotfiles/scripts/link.sh

# Install Oh My Zsh (only if not installed)
echo "Checking Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed ✓"
fi

echo "All done! Restart your terminal."
