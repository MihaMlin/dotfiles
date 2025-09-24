#!/bin/bash

# For SSH keys, create a script that generates new keys rather than storing the keys themselves
# To run this script, execute: bash ~/dotfiles/ssh/setup-ssh.sh
# Make sure script is executable: chmod +x ~/dotfiles/ssh/setup-ssh.sh

# Create SSH directory with proper permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Check if SSH key already exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
else
    echo "SSH key already exists."
fi

# Set proper permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

echo "SSH setup complete!"
EOF

# Make the script executable
chmod +x ~/dotfiles/ssh/setup-ssh.sh
