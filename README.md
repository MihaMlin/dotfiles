# Dotfiles

My personal configuration files for Zsh, Bash, Git, VSCode and other development tools.
Managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking.

## 🚀 Features

- **Zsh & Bash** configurations with Oh My Zsh
- **Git** aliases and global ignores
- **NVM** auto-installer
- **VS Code** settings sync
- **One-command setup**

## 📦 Prerequisites

### 1. Install Git & Stow

```bash
# Linux (Debian/Ubuntu)
sudo apt update && sudo apt install -y git stow
```

### 2. Clone Repository

```bash
git clone https://github.com/MihaMlin/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
```

## 🔧 Installation

### Automated Setup

```bash
./scripts/setup.sh
```

### Checkpoints

1. Symlink configurations (Zsh, Bash, Git, etc.)
2. Install Oh My Zsh
3. Install and configure NVM (Node Version Manager)
4. VS CODE settings (update)
