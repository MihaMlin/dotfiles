Dotfiles
========

XDG-compliant Linux/WSL dev environment — one script installs tools (nvm,
uv, zinit, fzf, …) and symlinks configs with [GNU Stow](https://www.gnu.org/software/stow/).

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Background

Three jobs, three places, no overlap:

1. **Install** — `scripts/install/*.sh` apt-installs or git-clones each tool
   to a deterministic [XDG](https://specifications.freedesktop.org/basedir-spec/latest/) path.
2. **Symlink** — Stow mirrors `stow/<package>/` into `$HOME`.
3. **Wire the shell** — `.zshrc` sources each tool's `path.zsh` so it's found
   and initialized automatically.

`docs/ZBOOK.md` covers the layer below this repo: a clean Windows 11 +
WSL2/Ubuntu setup, ending with cloning this repo.

## Install

```bash
ssh-keygen -t ed25519 -C "you@example.com"   # add the pubkey to GitHub
git clone git@github.com:MihaMlin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Idempotent — safe to re-run anytime. `./install.sh` apt-installs packages,
stows every `stow/*` package into `$HOME`, installs nvm/uv/zinit/fzf, and
sets zsh as the default shell. For a single step: `bash scripts/install/nvm.sh`
or a Makefile target (`make help` lists them all — `stow`, `unstow`, `update`,
`install-<tool>`, `lint`, …).

## Usage

```text
~/.dotfiles/
├── install.sh      # Main entry point
├── lib/            # Shared bash helpers (logging, git clone, preflight)
├── scripts/
│   ├── install/    # One installer per tool
│   └── setup/      # symlinks.sh (stow wrapper), default-zsh.sh
└── stow/           # One stow package per directory → symlinked into $HOME
```

Each `stow/<package>/` mirrors its internal structure into `$HOME`. Tools
that extend the shell (`nvm`, `uv`, `zinit`, `fzf`, …) carry a `path.zsh`
exporting the tool's own env var with an XDG fallback; `.zshrc` globs and
sources every `path.zsh` on startup, so a new package needs zero `.zshrc`
edits. Tools that just read `$XDG_CONFIG_HOME/<name>/` on their own (`git`,
`tmux`) don't need one.

**Adding a tool:** copy the pattern from an existing `stow/<tool>/.config/<tool>/path.zsh`,
add `scripts/install/<tool>.sh` if it needs installing (source `lib/log.sh`
and `lib/git-clone.sh`), and register it in `install.sh`'s `STEPS` array.

**Troubleshooting:** `stow` conflicts on first run mean real files already
sit where a symlink should go — `scripts/setup/symlinks.sh` passes `--adopt`
to pull them into the repo (check `git diff` after). Slow shell startup
almost always means a `path.zsh` doing eager work instead of lazy-loading.
Machine-specific config goes in `~/.localrc` (untracked, sourced last).

## Contributing

Personal dotfiles, tuned to one workflow — expect opinionated defaults.
Issues and small PRs welcome; open an issue first for anything larger.
Run `make lint` before submitting.

## License

None published — all rights reserved by default. Ask
[@MihaMlin](https://github.com/MihaMlin) about reuse.
