1. Prestavi vse config datoteke v stow folder za GNU Stow.
2. Popravi vse install datoteke za orodja, da bodo vse zelo podobne (morajo imeti neki standard).
3. Popravi install.sh datoteko za instaliranje novih orodij.
4. Popravi .zshrs in zsh folder

Spremeni symlinking v dotfiles tako da lahko uporabis GNU Stow

~/.dotfiles/
├── install.sh
├── scripts/
│   ├── lib/
│   │   ├── log.sh
│   │   ├── preflight.sh
│   │   └── git-clone.sh                # git_install() helper
│   ├── install/
│   │   ├── apt.sh
│   │   ├── zinit.sh
│   │   ├── nvm.sh
│   │   ├── pyenv.sh
│   │   ├── fzf.sh
│   │   └── neovim.sh
│   └── setup/
│       ├── symlinks.sh                 # kliče stow
│       └── default-zsh.sh
│
└── stow/                                # vse, kar gre v $HOME
    ├── zsh/                             # paket: zsh
    │   ├── .zshrc                       # → ~/.zshrc
    │   └── .config/zsh/                 # → ~/.config/zsh/
    │       ├── 00-tools.zsh             # source-a path.zsh-je iz orodij
    │       ├── 10-history.zsh
    │       ├── 20-completion.zsh
    │       ├── 30-aliases.zsh
    │       ├── 40-plugins.zsh           # zinit load ...
    │       └── 50-keybindings.zsh
    │
    ├── zinit/
    │   └── .config/zinit/
    │       └── path.zsh                 # → ~/.config/zinit/path.zsh
    │
    ├── nvm/
    │   └── .config/nvm/
    │       └── path.zsh
    │
    ├── pyenv/
    │   └── .config/pyenv/
    │       └── path.zsh
    │
    ├── fzf/
    │   └── .config/fzf/
    │       └── path.zsh
    │
    ├── nvim/
    │   └── .config/nvim/
    │       ├── init.lua
    │       └── ...
    │
    ├── git/
    │   └── .config/git/
    │       └── config
    │
    ├── tmux/
    │   └── .config/tmux/
    │       └── tmux.conf
    │
    └── bin/
        └── .local/bin/
            ├── backup
            ├── lsports
            ├── mini-fetch
            └── pycheck
