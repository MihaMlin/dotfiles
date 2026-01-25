# Dotfiles

Personal XDG-compliant development environment for Linux/WSL.

## ✨ Features

- **Performance First**: Lazy-loading for NVM, Pyenv, and Zinit Turbo mode for <300ms shell startup.
- **XDG Compliant**: Keeps `$HOME` clean. Configs live in `~/.config`, data in `~/.local/share`, state/history in `~/.local/state`.
- **Zsh Framework**:
  - **Plugins**: Managed via `zinit` for asynchronous loading.
  - **Theme**: Powerlevel10k (instant prompt enabled).
  - **Completion**: Optimized caching (rebuilds only once/day).
- **Toolchain**:
  - **Python**: `pyenv` for version management.
  - **Node**: `nvm` for version management.
  - **Terminal**: `tmux` with standard keybindings.

## 📂 Structure

```text
├── bin/          # Utility scripts (added to PATH)
├── config/       # Tool configurations (XDG_CONFIG_HOME)
│   ├── git/
│   ├── nvm/
│   ├── pyenv/
│   ├── tmux/
│   └── zinit/
├── scripts/
│   ├── install/   # Tool installers
│   ├── setup/     # Environment setup
│   ├── apt-packages.txt
│   └── symlinks.txt
├── zsh/          # Modular Zsh config
└── install.sh    # Main entry point
```

## 🚀 Quick Start

### Prerequisites

1. **SSH Keys** (for GitHub access):
   ```bash
   ssh-keygen -t ed25519 -C "email@example.com"
   # Add ~/.ssh/id_ed25519.pub to GitHub
   ```

2. **Clone & Install**:
   ```bash
   git clone git@github.com:MihaMlin/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ./install.sh
   ```

## 🛠️ Configuration

### Adding Tools
1. **System Packages**: Add package names to `scripts/linux/apt-packages.txt`.
2. **External Tools**: Create an installer in `scripts/linux/install/` and register it in `install.sh`.
3. **Shell Integration**:
   - Create `config/<tool>/path.zsh` for PATH exports (automatically sourced).
   - Use `lazy_load` functions if the tool is heavy.

### Managing Symlinks
Mappings are defined in `scripts/linux/symlinks.txt`:
```text
# source_in_dotfiles => target_on_system
zsh/.zshrc           => ~/.zshrc
config/tmux/tmux.conf => ~/.config/tmux/tmux.conf
```

### Zsh Customization
- **Aliases**: `zsh/aliases.zsh`
- **Plugins**: `zsh/plugins.zsh` (clean via `blockf`, `lucid`, `wait` ice modifiers)
- **Functions**: `zsh/integrations.zsh`

## 📚 Resources

- [Developer's Guide to Dotfiles](https://mskadu.medium.com/the-developers-guide-to-dot-files-versioning-your-development-environment-a4b642216680)
- [Zen Dotfiles YT](https://youtu.be/ud7YxC33Z3w?si=jFv5l_agBGGy5OLM)
