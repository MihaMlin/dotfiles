# Dotfiles

XDG-compliant development environment for Linux/WSL. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Table of contents

- [What this repo does](#what-this-repo-does)
- [Quick start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Re-running](#re-running)
- [Repo layout](#repo-layout)
- [Architecture](#architecture)
  - [How XDG works here](#how-xdg-works-here)
  - [How a tool flows through three layers](#how-a-tool-flows-through-three-layers)
  - [Why some tools need `path.zsh` and others don't](#why-some-tools-need-pathzsh-and-others-dont)
- [Adding a new tool](#adding-a-new-tool)
  - [How to write `path.zsh`](#how-to-write-pathzsh)
  - [File structure](#file-structure)
  - [Lazy-load template](#lazy-load-template)
  - [End-to-end steps](#end-to-end-steps)
- [Conventions](#conventions)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## What this repo does

Three things, each with one tool:

1. **Installs tools** — `scripts/install/*.sh` clones or apt-installs each tool to a deterministic XDG path.
2. **Symlinks configs** — GNU Stow mirrors `stow/<package>/` into `$HOME`.
3. **Wires shell** — `.zshrc` sources each tool's `path.zsh` so the shell can find and initialize it.

The three concerns live in three separate places. None duplicate each other.

## Quick start

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

The installer:
- Runs preflight checks (Linux, sudo available, git installed)
- Installs apt packages from `scripts/apt-packages.txt` (including `stow`)
- Runs each tool installer in `scripts/install/`
- Stows all packages from `stow/` into `$HOME`
- Sets zsh as the default shell

### Re-running

The installer is idempotent. Safe to re-run.

```bash
./install.sh                  # full
./install.sh --skip-apt       # skip apt step (faster on re-runs)
./install.sh --only-symlinks  # just re-stow (no sudo needed)
```

For a single tool:

```bash
bash scripts/install/nvm.sh   # re-install or update one tool
```

## Repo layout

```text
~/.dotfiles/
├── install.sh                    # Main entry point
├── scripts/
│   ├── lib/                      # Shared helpers (logging, git clone, preflight)
│   ├── install/                  # One installer per tool
│   └── setup/
│       ├── symlinks.sh           # Wraps `stow`
│       └── default-zsh.sh
└── stow/                         # Everything that gets symlinked into $HOME
    ├── zsh/                      # → ~/.zshrc + ~/.config/zsh/*
    ├── zinit/                    # → ~/.config/zinit/path.zsh
    ├── nvm/                      # → ~/.config/nvm/path.zsh
    ├── pyenv/                    # → ~/.config/pyenv/path.zsh
    ├── fzf/                      # → ~/.config/fzf/path.zsh
    ├── nvim/                     # → ~/.config/nvim/
    ├── git/                      # → ~/.config/git/
    ├── tmux/                     # → ~/.config/tmux/
    ├── claude/                   # → ~/.claude/
    └── bin/                      # → ~/.local/bin/
```

Each directory inside `stow/` is a **stow package**. Stow mirrors the package's internal structure into `$HOME`, creating symlinks that point back to the repo.

## Architecture

### How XDG works here

This repo follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/). Four environment variables decide where things live:

| Variable             | Default                | What goes here                                             |
| -------------------- | ---------------------- | -----------------------------------------------------------|
| `XDG_CONFIG_HOME`    | `~/.config`            | Configuration (read by tools)                              |
| `XDG_DATA_HOME`      | `~/.local/share`       | Persistent app data (plugins, version managers, databases) |
| `XDG_STATE_HOME`     | `~/.local/state`       | Logs, history, runtime state                               |
| `XDG_CACHE_HOME`     | `~/.cache`             | Disposable cached data                                     |

These are exported at the top of `.zshrc` so every tool started from the shell inherits them.

### How a tool flows through three layers

Take `zinit` as a worked example. The same pattern applies to every shell-extension tool (`nvm`, `pyenv`, `fzf`).

#### Layer 1: Install — where the tool's files live

`scripts/install/zinit.sh` clones zinit to `$XDG_DATA_HOME/zinit/zinit.git/`. The path is **not** hardcoded in the installer — it is sourced from the same `path.zsh` that the shell uses, so install location and runtime location can never disagree.

```bash
# scripts/install/zinit.sh (excerpt)
source "$DOTFILES_DIR/stow/zinit/.config/zinit/path.zsh"
git_install https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
```

#### Layer 2: Path declaration — single source of truth

`stow/zinit/.config/zinit/path.zsh` declares the location and conditionally sources the runtime:

```zsh
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -s "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"
```

After `stow zinit`, this file is symlinked at `~/.config/zinit/path.zsh`.

#### Layer 3: Shell init — pulling the tool into the session

`.zshrc` sources every `path.zsh` with one glob:

```zsh
for f in "$XDG_CONFIG_HOME"/*/path.zsh; do
    [[ -r "$f" ]] && source "$f"
done
```

Adding a new shell-extension tool requires zero edits to `.zshrc`. Drop a new stow package, run `stow`, the glob picks it up.

### Why some tools need `path.zsh` and others don't

Two categories. The distinction is whether the tool runs as a separate process (category 1) or extends the shell from inside (category 2).

#### Category 1 — no `path.zsh`, tool finds its own config

These tools are normal binaries on `$PATH` and read `$XDG_CONFIG_HOME/<name>/` automatically. Stow places the config there; the tool finds it. Done.

| Tool    | Why no `path.zsh`                                                                           |
| ------- | --------------------------------------------------------------------------------------------|
| `nvim`  | Apt-installed via PPA → `/usr/bin/nvim` (default `$PATH`). Reads `~/.config/nvim/init.lua`. |
| `git`   | System binary. Reads `~/.config/git/config`.                                                |
| `tmux`  | System binary. Reads `~/.config/tmux/tmux.conf`.                                            |
| `bin`   | Just user scripts symlinked to `~/.local/bin/`. No tool, no config to load.                 |

#### Category 2 — `path.zsh` required, tool extends the shell

These modify `$PATH`, define shell functions, or register hooks — work that must happen inside the running shell session. Their `path.zsh` exports the tool's location variable (so the tool knows where its data lives) and sources its runtime (so the shell gains the functions/bindings).

| Tool    | Var              | What `path.zsh`does                                                                        |
| ------- | ---------------- |--------------------------------------------------------------------------------------------|
| `zinit` | `ZINIT_HOME`     | Sources `zinit.zsh` to register the plugin manager.                                        |
| `nvm`   | `NVM_DIR`        | Defines lazy wrappers for `nvm`/`node`/`npm`/`npx`.                                        |
| `pyenv` | `PYENV_ROOT`     | Prepends `bin/` and `shims/` to `$PATH`; defines lazy wrappers for `pyenv`/`python`/`pip`. |
| `fzf`   | —                | Currently no `path.zsh` (fzf installer writes its own shell init via `--xdg`)              |

## Adding a new tool

### How to write `path.zsh`

`path.zsh` is the single source of truth for a tool's location. The shell sources it on startup; installers source it to learn where to put the tool. Seven rules:

1. **Use the tool's official env var name** — whatever the tool itself reads. `ZINIT_HOME` for zinit, `NVM_DIR` for nvm, `PYENV_ROOT` for pyenv. Don't invent names; if you set `NVM_ROOT`, the nvm runtime won't see it.
2. **Always `export`** — installers and child processes need to inherit it.
3. **Always include the XDG fallback** — `${XDG_DATA_HOME:-$HOME/.local/share}/<tool>`. Installers source `path.zsh` before `.zshrc` has a chance to export `XDG_*`, so the file must stand on its own.
4. **Source runtimes conditionally** — `[[ -s "$X" ]] && source "$X"`. The file may be sourced before the tool is installed; never fail the shell.
5. **No eager work at top level** — no `$(...)`, no `eval "$(... init -)"`. Anything that probes the filesystem or runs a binary belongs in a lazy-loader function. Eager work is the #1 cause of slow zsh startup.
6. **Installers must source `path.zsh`** — never hardcode the path in `scripts/install/<tool>.sh`. If `path.zsh` and the installer disagree, install location and runtime location drift apart.
7. **Bash-safe guard** — exports first, then `[[ -n "${ZSH_VERSION:-}" ]] || return 0`, then anything zsh-specific. Installers (bash) get the vars; the shell (zsh) gets the full runtime.

### File structure

Every `path.zsh` is split into two regions, divided by a bash-safety guard:

```zsh
# 1. VARS region — exports only. Bash-safe so installers can source the file.
export TOOL_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/<tool>"
[[ -d "$TOOL_HOME/bin" ]] && export PATH="$TOOL_HOME/bin:$PATH"

# 2. Bash-safety guard — installers stop here, zsh continues.
[[ -n "${ZSH_VERSION:-}" ]] || return 0

# 3. ZSH region — runtime sourcing, lazy-load wrappers, hooks.
[[ -s "$TOOL_HOME/init.zsh" ]] && source "$TOOL_HOME/init.zsh"
```

The guard exists because `path.zsh` is sourced from two contexts: zsh shells (which need the runtime) and bash installers (which need only the path). A zsh-only runtime like `zinit.zsh` would crash a bash installer without the guard.

### Lazy-load template

For tools that need `eval $(... init -)` or shell hooks:

```zsh
# <Tool> — lazy-loaded
export TOOL_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/<tool>"

[[ -n "${ZSH_VERSION:-}" ]] || return 0

_load_tool() {
    unset -f tool cmd1 cmd2
    eval "$(tool init -)"
}

tool() { _load_tool; tool "$@"; }
cmd1() { _load_tool; cmd1 "$@"; }
cmd2() { _load_tool; cmd2 "$@"; }
```

Wrappers replace themselves with the real tool on first invocation. Zero startup cost; one-time cost when first used.

### End-to-end steps

The pattern, end to end:

**1. Pick the install location.** Use `$XDG_DATA_HOME/<tool>` for git-cloned tools.

**2. Create `stow/<tool>/.config/<tool>/path.zsh`** — follow the rules and template above.

**3. Create `scripts/install/<tool>.sh`** — source `path.zsh` to learn the install path:

```bash
#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
source "$DOTFILES_DIR/scripts/lib/log.sh"
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
source "$DOTFILES_DIR/stow/<tool>/.config/<tool>/path.zsh"

git_install https://github.com/owner/<tool>.git "$TOOL_HOME"
success "<tool> installed at $TOOL_HOME"
```

**4. Register the installer in `install.sh`:**

```bash
installers=(
    # ...existing...
    "scripts/install/<tool>.sh"
)
```

**5. Run:**

```bash
./install.sh
```

That's it. No edits to `.zshrc` — the glob in `00-tools.zsh` picks up the new `path.zsh` automatically.

## Conventions

- **Performance**: lazy-loading for `nvm` and `pyenv`; `zinit` runs plugins in turbo mode. Target startup: <300ms.
- **Local overrides**: machine-specific config goes in `~/.localrc`, auto-sourced by `.zshrc`. Not tracked in git.
- **Backups**: stow refuses to overwrite real files. On first migration, move existing configs out of `$HOME` (or use `stow --adopt`, then verify `git diff` before committing).

## Troubleshooting

**`stow` reports conflicts on first run.**
You have real files in `$HOME` where stow wants to place symlinks. Either move them aside (`mv ~/.zshrc ~/.zshrc.bak`) or use `stow --adopt` to pull them into the repo (then check `git diff` to confirm content is what you expect).

**A tool isn't found after install.**
Check the three layers in order: (1) does the install path exist? `ls $XDG_DATA_HOME/<tool>`; (2) is the symlink correct? `ls -la ~/.config/<tool>/path.zsh`; (3) did `.zshrc` source it? Open a new shell and run `echo $TOOL_HOME`.

**Shell startup is slow.**
Run `zsh -xv 2>&1 | head -100` to see what's loading early. Common cause: a `path.zsh` doing eager work that should be lazy.

## Resources

- [GNU Stow manual](https://www.gnu.org/software/stow/manual/stow.html)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
- [ArchWiki: XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory) — list of which tools respect XDG and how to force the rest
