# Design: Replace pyenv with uv as the Python version manager

Date: 2026-07-11
Status: Approved by user, pending implementation plan

## Goal

Replace `pyenv` with [`uv`](https://docs.astral.sh/uv/) as the dotfiles repo's
Python version manager. `uv` installs prebuilt Python distributions rather than
compiling from source, so a fresh machine gets a working `python` without any
build toolchain — this removes the need for pyenv's C build-dependency chain
and works even when the target machine starts with zero Python installed.

Success criteria: after `./install.sh` (or `./install.sh --skip-apt`) on a
clean machine, `uv` and a default `python`/`python3` are on `PATH`, the same
set of Python versions previously declared for pyenv are installed via uv, and
no pyenv artifacts remain in the repo.

## Required functionality

- Install the `uv` binary itself, idempotently (safe to re-run).
- Install a declared set of Python versions via `uv`, mirroring the existing
  `label:version` list format used for pyenv (labels are documentation only;
  only the version is acted on).
- Designate one version as the systemwide default so a bare `python`/`python3`
  works in any shell immediately after install, matching current pyenv
  behavior (`pyenv global`).
- Integrate with the repo's existing stow-based tool convention: one
  `path.zsh` per tool under `stow/<tool>/.config/<tool>/`, auto-sourced by
  `.zshrc`, serving as the single source of truth for that tool's env vars.
- Update the shell aliases that currently target pyenv commands to their uv
  equivalents, preserving the same alias names/shape where a direct
  equivalent exists.
- Remove pyenv entirely: installer script, environments file, stow package,
  and all references in documentation and aliases.
- Remove apt packages that existed solely to support building Python from
  source for pyenv (the C library headers / build toolchain group). Packages
  unrelated to that purpose (e.g. `python3`, `python3-pip` as general system
  essentials) are out of scope and stay as-is.

## Constraints

- Follow the existing installer pattern in `scripts/install/`: idempotent,
  sourced `log.sh` for output, `DOTFILES_DIR`-relative paths, matches the
  style of the other installers (`pyenv.sh`, `nvm.sh`, `fzf.sh`).
- The `uv` installer must not modify shell rc files (`.zshrc`, `.bashrc`,
  etc.) — this repo centralizes all PATH/env management through
  `path.zsh` files, and no other tool's installer is allowed to write to
  shell profiles either.
- No new system-wide build dependencies introduced.
- Directory locations for uv's binary, managed Python installs, and tool
  installs must respect XDG Base Directory conventions already established
  in `.zshrc` (`XDG_DATA_HOME`, `BIN_HOME`), consistent with how pyenv/nvm/fzf
  do it today.
- No changes to how other tools (nvm, fzf, zinit) are installed or structured.

## Edge cases

- Re-running the installer when `uv` is already present must not error or
  reinstall unnecessarily.
- Re-running Python version installation for versions already installed must
  be a no-op (matches current pyenv.sh behavior of checking before install).
- Missing `uv-environments.txt` (renamed from `pyenv-environments.txt`) must
  degrade gracefully — warn and skip version installation, not fail the whole
  install run (matches current pyenv.sh/nvm.sh behavior for missing env files).
- `install.sh --skip-apt` still works: uv/Python install doesn't depend on the
  apt step having just run (only on the packages already being present from a
  prior run, same assumption as today).

## Non-goals

- Not migrating to uv's idiomatic per-project `.python-version` / `uv run`
  workflow as the primary interface — the systemwide-default-version model
  (closest equivalent to current pyenv usage) is preserved.
- Not touching `nvm`, `fzf`, `zinit`, or any non-Python tooling.
- Not adding `uv` support for managing project virtualenvs/dependencies
  (`uv add`, `uv sync`, etc.) beyond Python version installation — that's a
  separate, later concern if ever needed.
- Not removing `python3`/`python3-pip` from apt Essentials.
