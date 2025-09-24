# Dotfiles

My personal configuration files for Bash, Docker, Git, SSH, VSCode and ZSH.
Managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking.

## 🚀 Features

- **Bash**: minimal config because I use Zsh  
- **Zsh**: configurations with Oh My Zsh  
- **Git**: aliases and global ignores  
- **VS Code**: settings sync  
- **One-command setup** for all configurations

## 🔧 Installation

### Automated Setup

```bash
# Clone Repository
git clone https://github.com/MihaMlin/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles

# Run automated setup script
./bootstrap.sh
```

### Checkpoints

1. Symlink configurations with bootstrap.sh (Zsh, Bash, Git, etc.)
2. Install Oh My Zsh
3. Install and configure NVM (Node Version Manager)
4. Install and configure PyEnv
