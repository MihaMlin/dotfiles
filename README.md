# Dotfiles

My personal configuration files for Docker, Git, VSCode and ZSH.  

## 🚀 Features

- **Zsh**: configurations with plugin manager ZInit    
- **Git**: aliases and global ignores  
- **VS Code**: settings sync  
- **One-command setup** for all configurations

## 🔧 Installation

### 0. Setup SSH for GitHub
```bash
sudo apt update && sudo apt upgrade -y

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
Verify if SSH is setup correctly:  
```bash
ssh -T git@github.com
```

### 1. Configure Git & Clone the Repository
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git -y

git config --global user.name "Miha Mlinaric"
git config --global user.email "mlinmiha@gmail.com"

git clone git@github.com:MihaMlin/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
```

### 2. Run the installation script
```bash
./install.sh
```
This will do:
- Install apt packages: git, zsh, tmux, curl, wget, vim, ...
- Install tools with git/curl: nvm, pyenv, zinit, ...
- Setup zsh as the default shell
- Setup symlinks from dotfiles to $HOME
- Start new shell session

### 3. Info

#### 3.1 Installing apt packages
Add package name to apt-packages.txt and it will be installed.

#### 3.2 Installing other tools  
Add install script for tool to **scripts/tools folder**.  
Add name of new install script to **install.sh** installer variable in main function.  
To initialize tool in ZSH create a **TOOL/path.zsh** file (which will be sourced in .zshrc).  

#### 3.3 Add symlink to dotfile  
To add a symlink to dotfile add the **source_file** and **target_location** to **scripts/system/symlinks.txt** file.  

#### 3.4 Installing zsh plugins & themes  
The plugin/theme manager we are using is **zinit**.  
To add a plugin add it with zinit in **zsh/plugins.zsh** and then integrate it in **zsh/integrations.zsh**.  
To add a theme add it with zinit in **zsh/plugins.zsh** and then add the theme file to **zsh/themes folder** and symlink it in **scripts/system/symlinks.txt** file.  


## 🔗 Usefull Links
[Guide to dotfiles](https://mskadu.medium.com/the-developers-guide-to-dot-files-versioning-your-development-environment-a4b642216680)
