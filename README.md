# Dotfiles

Personal development environment configuration for Zsh, Git, VSCode, and Docker.

## ✨ Features

- **Zsh** - Shell configuration with Zinit plugin manager
- **Git** - Custom aliases and global ignore patterns
- **VS Code** - Synchronized editor settings
- **Docker** - Container development setup
- **Automated installation** - One command to set up everything

## 🚀 Quick Start

Complete setup guide for fresh Linux installations.

### Prerequisites

#### SSH Configuration for GitHub

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Create SSH directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"

# Set permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

Add your public key to GitHub:
1. Copy key: `cat ~/.ssh/id_ed25519.pub`
2. Navigate to **GitHub → Settings → SSH and GPG keys → New SSH key**
3. Paste and save

Verify connection:
```bash
ssh -T git@github.com
```

### Installation

#### 1. Clone Repository

```bash
# Install Git
sudo apt update && sudo apt upgrade -y
sudo apt install git -y

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Clone dotfiles
git clone git@github.com:MihaMlin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

#### 2. Run Installer

```bash
./install.sh
```

The script will:
- Install essential packages (git, zsh, tmux, curl, wget, vim, etc.)
- Install development tools (nvm, miniforge/mamba, zinit)
- Configure Zsh as default shell
- Create symlinks for all dotfiles
- Initialize new shell session

## 📝 Configuration Guide

### Adding APT Packages

Add package names to `apt-packages.txt` - they will be installed automatically.

### Installing Additional Tools

1. Create installation script in `scripts/tools/`
2. Add script name to `installer` variable in `install.sh`
3. Create `TOOL/path.zsh` for Zsh initialization (sourced in `.zshrc`)

### Managing Symlinks

Add entries to `scripts/system/symlinks.txt`:
```
source_file target_location
```

### Configuring Zsh

**Plugins and themes** are managed via Zinit:
- Add plugins in `zsh/plugins.zsh`
- Configure integrations in `zsh/integrations.zsh`
- For themes: add to `zsh/plugins.zsh`, create theme file in `zsh/themes/`, and symlink via `scripts/system/symlinks.txt`

### Adding Binary Scripts

1. Place script in `/bin/` directory
2. Remove file extension
3. Include shebang at top of file
4. Make executable: `chmod +x /bin/script-name`

## 📚 Resources

- [Developer's Guide to Dotfiles](https://mskadu.medium.com/the-developers-guide-to-dot-files-versioning-your-development-environment-a4b642216680)
- [Zen Dotfiles YT](https://youtu.be/ud7YxC33Z3w?si=jFv5l_agBGGy5OLM)
