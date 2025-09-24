# Dotfiles

My personal configuration files for Docker, Git, VSCode and ZSH.  
Managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking.

## 🚀 Features

- **Zsh**: configurations with Oh My Zsh  
- **Git**: aliases and global ignores  
- **VS Code**: settings sync  
- **One-command setup** for all configurations

## 🔧 Installation

### 0. Setup SSH for GitHub
```bash
# Make directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate key
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"

# Set proper permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```
Copy your public key `cat ~/.ssh/id_ed25519.pub` and paste it to: **GitHub → Settings → SSH and GPG keys → New SSH key**.

### 1. Clone the Repository
```bash
git clone git@github.com:MihaMlin/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
```

### 2. Run the bootstrap script
```bash
./bootstrap.sh
```

### 3. Other programs to install
- Oh-My-Zsh
- NVM (Node Version Manager)
- PyEnv

## 🔗 Usefull Links
[Guide to dotfiles](https://mskadu.medium.com/the-developers-guide-to-dot-files-versioning-your-development-environment-a4b642216680)
