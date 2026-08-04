Dotfiles
========

XDG-compliant Linux/WSL development environment: apt packages, dev tools
(nvm, uv, zinit, fzf), shell config, and app configs — installed and
symlinked with one script.

## Table of Contents

- [Background](#background)
  - [How XDG works here](#how-xdg-works-here)
- [Install](#install)
  - [Prerequisites](#prerequisites)
  - [Re-running / updating](#re-running--updating)
- [Usage](#usage)
  - [Repo layout](#repo-layout)
  - [Stow packages](#stow-packages)
  - [Adding a new tool](#adding-a-new-tool)
  - [`stow/bin/` scripts](#stowbin-scripts)
  - [Troubleshooting](#troubleshooting)
- [Maintainers](#maintainers)
- [Contributing](#contributing)
- [License](#license)

## Background

This repo turns a bare Linux (or WSL) install into a working dev environment
in one command, and keeps it reproducible. It does three things, each in one
place, so none of them duplicate each other:

1. **Installs tools** — `scripts/install/*.sh` apt-installs or git-clones each
   tool to a deterministic XDG path.
2. **Symlinks configs** — [GNU Stow](https://www.gnu.org/software/stow/)
   mirrors `stow/<package>/` into `$HOME`.
3. **Wires the shell** — `.zshrc` sources each tool's `path.zsh` so the shell
   finds and initializes it.

A companion guide, [`docs/ZBOOK.md`](docs/ZBOOK.md), covers the layer below
this repo: a clean Windows 11 install and WSL2/Ubuntu setup, ending with
cloning this repo.

### How XDG works here

The repo follows the
[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).
`.zshenv` exports the four variables before anything else runs, so every
tool started from the shell inherits them:

| Variable          | Default           | What goes here                                              |
| ------------------ | ----------------- | ------------------------------------------------------------ |
| `XDG_CONFIG_HOME`   | `~/.config`        | Configuration (read by tools)                                |
| `XDG_DATA_HOME`     | `~/.local/share`   | Persistent app data (plugins, version managers, databases)   |
| `XDG_STATE_HOME`    | `~/.local/state`   | Logs, history, runtime state                                 |
| `XDG_CACHE_HOME`    | `~/.cache`         | Disposable cached data                                       |

`.zshenv` also exports `BIN_HOME` (`~/.local/bin`) and `ZDOTDIR`
(`$XDG_CONFIG_HOME/zsh`) — the latter is what lets `.zshrc` and the numbered
`stow/zsh/.config/zsh/*.zsh` modules live outside `$HOME` at all.

## Install

### Prerequisites

```bash
# 1. SSH key for GitHub
ssh-keygen -t ed25519 -C "you@example.com"
# Add ~/.ssh/id_ed25519.pub to GitHub

# 2. Clone
git clone git@github.com:MihaMlin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. Install
./install.sh
```

`install.sh` takes no arguments and runs, in order:

1. `scripts/install/apt.sh` — apt packages (see the `PACKAGES` array),
   including `stow`.
2. `scripts/setup/symlinks.sh` — stows every package in `stow/` into `$HOME`.
3. `scripts/install/nvm.sh`, `uv.sh`, `zinit.sh`, `fzf.sh` — one tool each.
4. `scripts/setup/default-zsh.sh` — installs zsh if needed and sets it as
   the default shell.

### Re-running / updating

The whole pipeline is idempotent — safe to re-run in full:

```bash
./install.sh
```

For a single step, run its script directly (`bash scripts/install/nvm.sh`)
or use a Makefile target:

| Target                                                              | Does                                                   |
| ---------------------------------------------------------------------| --------------------------------------------------------|
| `make install`                                                        | Full install (same as `./install.sh`)                    |
| `make update`                                                          | Re-run installers to pick up new versions (skips apt)      |
| `make stow` / `make unstow`                                             | Symlink / remove symlinks only, no sudo                     |
| `make apt`                                                               | apt packages only                                             |
| `make install-nvm` / `install-uv` / `install-zinit` / `install-fzf`       | Install a single tool                                            |
| `make shell`                                                                | Set zsh as the default shell                                       |
| `make lint`                                                                   | Shellcheck every script                                              |
| `make help`                                                                     | List all targets                                                       |

## Usage

### Repo layout

```text
~/.dotfiles/
├── Makefile                # `make help` for available commands
├── install.sh               # Main entry point
├── docs/ZBOOK.md             # Windows 11 + WSL2 setup guide (pre-clone)
├── vscode/                   # VS Code settings/keybindings, kept for reference (not stowed)
├── lib/                       # Shared bash helpers
│   ├── log.sh                    # info/warning/success/error/running/step
│   ├── git-clone.sh               # git_install: clone or update-to-latest-tag
│   └── preflight.sh                # sanity checks + creates XDG dirs
├── scripts/
│   ├── install/                  # One installer per tool (apt, nvm, uv, zinit, fzf)
│   └── setup/
│       ├── symlinks.sh              # Wraps `stow` for every stow/* package (supports --delete)
│       └── default-zsh.sh            # Installs zsh, chsh -s zsh
└── stow/                       # Everything that gets symlinked into $HOME — one stow package per directory
```

Each directory inside `stow/` is a **stow package**: Stow mirrors its
internal structure (relative to the package root) into `$HOME`, creating
symlinks that point back into the repo.

### Stow packages

| Package       | Symlinked to                     | Installed by                                                                  |
| -------------- | ---------------------------------- | -------------------------------------------------------------------------------|
| `zsh`           | `~/.zshenv`, `~/.config/zsh/*`       | apt (`zsh`)                                                                      |
| `zinit`         | `~/.config/zinit/path.zsh`            | `scripts/install/zinit.sh`                                                        |
| `nvm`           | `~/.config/nvm/path.zsh`               | `scripts/install/nvm.sh`                                                            |
| `uv`            | `~/.config/uv/path.zsh`                 | `scripts/install/uv.sh`                                                               |
| `fzf`           | `~/.config/fzf/path.zsh`                 | `scripts/install/fzf.sh`                                                                |
| `git`           | `~/.config/git/config`                    | apt (`git`)                                                                              |
| `tmux`          | `~/.config/tmux/tmux.conf`                 | apt (`tmux`)                                                                              |
| `npm`           | `~/.config/npm/npmrc`                       | comes with `nvm`                                                                            |
| `docker`        | `~/.config/docker/`                          | Docker, installed separately                                                                  |
| `ipython`       | `~/.config/ipython/`                          | comes with Python                                                                                |
| `jupyter`       | `~/.config/jupyter/`                           | comes with Python                                                                                  |
| `cookiecutter`  | `~/.config/cookiecutter/config.yaml`            | installed separately                                                                                  |
| `wget`          | `~/.config/wget/wgetrc`                          | apt (`wget`)                                                                                            |
| `claude`        | `~/.claude/`                                      | [Claude Code](https://claude.com/product/claude-code), installed separately                              |
| `bin`           | `~/.local/bin/*`                                   | n/a — plain scripts, see [`stow/bin/` scripts](#stowbin-scripts)                                            |

Packages with a `path.zsh` are picked up automatically: `.zshrc` globs and
sources every `$XDG_CONFIG_HOME/*/path.zsh` on shell start, before the
numbered `stow/zsh/.config/zsh/[0-9][0-9]-*.zsh` modules run. `git`, `tmux`,
and `bin` need no `path.zsh` at all — `git`/`tmux` are binaries that already
read `$XDG_CONFIG_HOME/<name>/` on their own, and `bin` is just scripts on
`$PATH` with nothing to initialize.

`nvm`'s `path.zsh` is the one exception to "lazy by default": it loads
eagerly despite defining lazy wrappers for `nvm`/`node`/`npm`/`npx`, because
non-interactive callers (e.g. Claude Code invoking `node`/`npm` directly)
never trigger a lazy wrapper.

### Adding a new tool

1. **Pick the install location** — `$XDG_DATA_HOME/<tool>` for git-cloned
   tools, or nothing if the tool already respects XDG on its own.
2. **Create `stow/<tool>/.config/<tool>/path.zsh`**, if the tool needs one:
   - Use the tool's own env var name (e.g. `NVM_DIR`, not `NVM_ROOT`).
   - Always `export`, and always include the
     `${XDG_DATA_HOME:-$HOME/.local/share}` fallback — installers source
     `path.zsh` before `.zshrc` sets `XDG_*`.
   - Source runtimes conditionally: `[[ -s "$X" ]] && source "$X"` — the
     file may be sourced before the tool is installed.
   - No eager work at top level (`$(...)`, `eval "$(... init -)"`) — put
     it behind a lazy-load function, or shell startup slows down.
   - Guard zsh-only code so bash installers can still source the file:
     `[[ -n "${ZSH_VERSION:-}" ]] || return 0`.
3. **Create `scripts/install/<tool>.sh`**, if it needs installing — source
   `path.zsh` to learn the install path (never hardcode it), then use
   `lib/git-clone.sh`'s `git_install <url> <dest>` for git-based tools.
   Log with `lib/log.sh` (`info`/`warning`/`success`/`error`), end with
   `success "<tool> installed at $LOCATION"`.
4. **Register the installer** in `install.sh`'s `STEPS` array. It's already
   runnable standalone via `bash scripts/install/<tool>.sh` or
   `make install-<tool>` (the `install-%` Makefile target covers any script
   under `scripts/install/`).
5. **Run `./install.sh`** (or just `make stow` if there's nothing to
   install). No `.zshrc` edit needed — the `path.zsh` glob picks up the new
   file automatically.

### `stow/bin/` scripts

`stow/bin/.local/bin/` holds standalone CLI utilities symlinked onto
`$PATH`: `backup`, `lsports`, `mini-fetch`, `pycheck`. Unlike
`scripts/install/`, they run as everyday commands and must keep working
even if this repo is moved or removed, so they stay self-contained — no
`DOTFILES_DIR`, no sourcing `lib/log.sh`. Convention: shebang + one-line
purpose comment, `set -euo pipefail`, `[[ ... ]]` conditionals, errors to
stderr with a non-zero exit.

### Troubleshooting

**`stow` reports conflicts on first run.**
Real files already exist in `$HOME` where stow wants to place symlinks.
Move them aside (`mv ~/.zshrc ~/.zshrc.bak`) — or note that
`scripts/setup/symlinks.sh` already passes `--adopt`, which pulls existing
files into the repo instead of failing; check `git diff` afterward to
confirm the adopted content is what you expect.

**A tool isn't found after install.**
Check the three layers in order: (1) does the install path exist —
`ls $XDG_DATA_HOME/<tool>`; (2) is the symlink correct —
`ls -la ~/.config/<tool>/path.zsh`; (3) did `.zshrc` source it — open a new
shell and `echo $TOOL_HOME` (or the tool's own var).

**Shell startup is slow.**
Run `zsh -xv 2>&1 | head -100` to see what loads early. Usual cause: a
`path.zsh` doing eager work (a `$(...)` or `eval "$(... init -)"` at top
level) that should be behind a lazy-load function instead.

**Machine-specific config leaking into git.**
Put it in `~/.localrc` — `.zshrc` sources it last, and it's not tracked.

## Maintainers

[@MihaMlin](https://github.com/MihaMlin)

## Contributing

This is a personal dotfiles repo, tuned to one workflow — expect opinionated
defaults. Issues and PRs are still welcome, especially for bugs in the
install scripts or `path.zsh` conventions; for anything larger, open an
issue first to discuss the change. Run `make lint` (shellcheck) before
submitting.

## License

No license file is currently published in this repository; all rights
reserved by default. Ask the maintainer if you'd like to reuse anything
here.
