# Installer Standardization + Makefile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every script in `scripts/install/` and `scripts/setup/` follow one fixed section order and one inline-array config convention, and add a `Makefile` as a thin entry point over the existing `install.sh`.

**Architecture:** No new abstraction layer. Each installer keeps its current responsibility and tool-specific logic; only file *shape* changes (section order, array-in-file instead of sidecar `.txt`, `log.sh`-only output). `Makefile` targets are one-line wrappers that call `install.sh` or `scripts/setup/symlinks.sh` — no orchestration logic duplicated.

**Tech Stack:** bash, GNU Make, GNU Stow, shellcheck.

## Global Constraints

- No new external dependencies beyond `shellcheck` (added to the apt `PACKAGES` array so `make lint` works after a fresh install — resolves the spec's open question).
- `install.sh`'s CLI surface (`--skip-apt`, `--only-symlinks`, `-h`/`--help`) does not change.
- No change to `stow/` package contents, `vscode/`, or `docs/` beyond this plan's own spec/plan files.
- No change to how `neovim.sh`, `zinit.sh`, `fzf.sh` install their tools — reordering only, no behavior change.
- All installer output goes through `scripts/lib/log.sh` (`info`/`warning`/`success`/`error`) — never raw `echo`. All messages/comments in English.
- Every `scripts/install/*.sh` and `scripts/setup/*.sh` file follows this section order: shebang + one-line purpose comment → `set -euo pipefail` → `DOTFILES_DIR` + `source` block (each `source` preceded by `# shellcheck source=`) → optional config array fenced by `# --- Config (edit here) ---` / `# --- end config ---` → body → `success "..."` as the final line.
- Destructive/system-modifying commands (`sudo apt install`, `git clone`, `stow --delete` against the real `$HOME`, `make install`/`stow`/`unstow`/`update`) are never run automatically during verification in this plan — verification uses `bash -n` and `shellcheck` (static checks only). Running the real targets is left to the user, after review.

---

### Task 1: Standardize `apt.sh`

**Files:**
- Modify: `scripts/install/apt.sh`
- Delete: `scripts/install/apt-packages.txt`

**Interfaces:**
- Produces: `PACKAGES` bash array (used only within this file).

- [ ] **Step 1: Rewrite `scripts/install/apt.sh`**

```bash
#!/usr/bin/env bash
# Install system packages via apt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

# --- Config (edit here) ---
PACKAGES=(
    # Essentials
    "build-essential"
    "cmake"
    "curl"
    "git"
    "jq"
    "python3"
    "python3-pip"
    "shellcheck"
    "stow"
    "tmux"
    "unzip"
    "vim"
    "wget"
    "zsh"
    # Useful
    "htop"
    "tree"
    "neofetch"
    "inxi"
    "traceroute"
    "nmap"
)
# --- end config ---

info "Updating apt and upgrading existing packages..."
sudo apt update
sudo apt upgrade -y

info "Installing ${#PACKAGES[@]} package(s)..."
sudo apt install -y "${PACKAGES[@]}"
sudo apt autoremove -y
sudo apt clean
success "${#PACKAGES[@]} packages installed"
```

- [ ] **Step 2: Delete the sidecar file**

Run: `git rm scripts/install/apt-packages.txt`

- [ ] **Step 3: Verify**

Run: `bash -n scripts/install/apt.sh`
Expected: no output (syntax OK).

If `shellcheck` is available locally, also run: `shellcheck scripts/install/apt.sh`
Expected: no warnings. (If `shellcheck` is not installed on this machine, skip — it will be checked by `make lint` in Task 9 / after a future `make install`.)

- [ ] **Step 4: Commit**

```bash
git add scripts/install/apt.sh
git commit -m "refactor: inline apt package list into apt.sh, add shellcheck"
```

---

### Task 2: Standardize `nvm.sh`

**Files:**
- Modify: `scripts/install/nvm.sh`
- Delete: `scripts/install/nvm-environments.txt`

**Interfaces:**
- Consumes: `NVM_DIR` (exported by `stow/nvm/.config/nvm/path.zsh`), `git_install()` (from `scripts/lib/git-clone.sh`).
- Produces: `VERSIONS` bash array (used only within this file).

- [ ] **Step 1: Rewrite `scripts/install/nvm.sh`**

```bash
#!/usr/bin/env bash
# Install nvm (Node Version Manager) and Node.js versions.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/nvm/.config/nvm/path.zsh
source "$DOTFILES_DIR/stow/nvm/.config/nvm/path.zsh"

# --- Config (edit here) ---
VERSIONS=(
    "v18.20.8"
    "--lts"
)
# --- end config ---

NVM_VERSION="v0.40.3"

info "Installing nvm $NVM_VERSION..."
git_install "https://github.com/nvm-sh/nvm.git" "$NVM_DIR" --branch "$NVM_VERSION" --depth 1

# Load nvm directly — path.zsh's lazy-load wrapper is zsh-only.
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

for version in "${VERSIONS[@]}"; do
    info "Installing Node.js $version..."
    nvm install "$version"
done

success "nvm installed at $NVM_DIR"
```

This also fixes a real bug: the old file called `warn` (undefined in `log.sh`, which only defines `warning`) in its now-removed missing-file fallback path.

- [ ] **Step 2: Delete the sidecar file**

Run: `git rm scripts/install/nvm-environments.txt`

- [ ] **Step 3: Verify**

Run: `bash -n scripts/install/nvm.sh`
Expected: no output (syntax OK).

If available: `shellcheck scripts/install/nvm.sh` → no warnings.

- [ ] **Step 4: Commit**

```bash
git add scripts/install/nvm.sh
git commit -m "refactor: inline nvm version list into nvm.sh, fix warn->warning bug"
```

---

### Task 3: Standardize `uv.sh`

**Files:**
- Modify: `scripts/install/uv.sh`
- Delete: `scripts/install/uv-environments.txt`

**Interfaces:**
- Consumes: `UV_INSTALL_DIR` (exported by `stow/uv/.config/uv/path.zsh`).
- Produces: `VERSIONS` bash array (used only within this file); `VERSIONS[0]` is the version set as the global default.

- [ ] **Step 1: Rewrite `scripts/install/uv.sh`**

```bash
#!/usr/bin/env bash
# Install uv and Python versions.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../../stow/uv/.config/uv/path.zsh
source "$DOTFILES_DIR/stow/uv/.config/uv/path.zsh"

# --- Config (edit here) ---
VERSIONS=(
    "3.10.13"   # default
    "3.11.7"    # deep_learning
    "3.12.1"    # web_api
)
# --- end config ---

if command -v uv &>/dev/null; then
    info "uv already installed."
else
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

# Make uv callable for the rest of this script, even on first install.
export PATH="$UV_INSTALL_DIR:$PATH"

for version in "${VERSIONS[@]}"; do
    info "Installing Python $version..."
    # uv python install is idempotent (no-ops if already present).
    uv python install "$version"
done

first_version="${VERSIONS[0]}"
uv python install "$first_version" --default
uv python pin --global "$first_version"
info "Global Python set to $first_version"

success "uv installed at $UV_INSTALL_DIR"
```

Note: `"3.10.13"   # default` — the trailing `# label` is a shell comment after the quoted array element, not part of the value; `${VERSIONS[0]}` evaluates to exactly `3.10.13`.

- [ ] **Step 2: Delete the sidecar file**

Run: `git rm scripts/install/uv-environments.txt`

- [ ] **Step 3: Verify**

Run: `bash -n scripts/install/uv.sh`
Expected: no output (syntax OK).

If available: `shellcheck scripts/install/uv.sh` → no warnings.

- [ ] **Step 4: Commit**

```bash
git add scripts/install/uv.sh
git commit -m "refactor: inline uv python version list into uv.sh"
```

---

### Task 4: Standardize `neovim.sh` and `zinit.sh`

**Files:**
- Modify: `scripts/install/neovim.sh`
- Modify: `scripts/install/zinit.sh`

**Interfaces:**
- None (no behavior change — comment-block cleanup only).

Both files currently have a stray blank `#` comment line between the shebang and the purpose comment. `scripts/install/fzf.sh` already matches the target shape — verify only, no edit needed.

- [ ] **Step 1: Edit `scripts/install/neovim.sh`**

Remove the blank `#` line so the file reads:

```bash
#!/usr/bin/env bash
# Install the latest Neovim from the unstable PPA.
# Config (init.lua) is symlinked separately via stow/nvim/.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Installing Neovim from PPA..."
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

success "Neovim installed: $(nvim --version | head -1)"
```

- [ ] **Step 2: Edit `scripts/install/zinit.sh`**

Remove the blank `#` line so the file reads:

```bash
#!/usr/bin/env bash
# Install Zinit plugin manager for Zsh.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/zinit/.config/zinit/path.zsh
source "$DOTFILES_DIR/stow/zinit/.config/zinit/path.zsh"

info "Installing Zinit..."
git_install https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
success "Zinit installed at $ZINIT_HOME"
```

- [ ] **Step 3: Confirm `fzf.sh` needs no change**

Run: `head -3 scripts/install/fzf.sh`
Expected:
```
#!/usr/bin/env bash
# Install fzf (fuzzy finder).

```
This already matches the template — no edit.

- [ ] **Step 4: Verify**

Run: `bash -n scripts/install/neovim.sh scripts/install/zinit.sh`
Expected: no output.

If available: `shellcheck scripts/install/neovim.sh scripts/install/zinit.sh` → no warnings.

- [ ] **Step 5: Commit**

```bash
git add scripts/install/neovim.sh scripts/install/zinit.sh
git commit -m "style: drop stray blank comment line in neovim.sh, zinit.sh"
```

---

### Task 5: Standardize `symlinks.sh`, add `--delete`

**Files:**
- Modify: `scripts/setup/symlinks.sh`

**Interfaces:**
- Consumes: nothing new.
- Produces: `symlinks.sh --delete` — new CLI flag that Task 7's `Makefile` `unstow` target depends on. With no argument, behavior is unchanged (`--restow --adopt`).

- [ ] **Step 1: Rewrite `scripts/setup/symlinks.sh`**

```bash
#!/usr/bin/env bash
# Symlink (or remove symlinks for) stow packages into $HOME.
# Usage: symlinks.sh [--delete]

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

STOW_DIR="$DOTFILES_DIR/stow"
STOW_ACTION_ARGS=(--restow --adopt)
ACTION_LABEL="Symlinking"
if [[ "${1:-}" == "--delete" ]]; then
    STOW_ACTION_ARGS=(--delete)
    ACTION_LABEL="Unlinking"
fi

if ! command -v stow &>/dev/null; then
    info "Installing stow..."
    sudo apt update
    sudo apt install -y stow
fi

info "$ACTION_LABEL packages from $STOW_DIR into $HOME..."

for pkg_path in "$STOW_DIR"/*/; do
    pkg=$(basename "$pkg_path")
    info "Processing: $pkg"

    stow --dir="$STOW_DIR" --target="$HOME" "${STOW_ACTION_ARGS[@]}" --no-folding --verbose=2 "$pkg" 2>&1 | while read -r line; do
        if [[ $line == *"LINK"* ]]; then
            echo "  🔗 $line"
        fi
    done
done

success "$ACTION_LABEL complete. Check with: ls -la ~"
```

Changes from the original: purpose comment added, raw `echo "Symlinking dotfiles to: $HOME"` replaced by `info`, the Slovenian closing string ("Preveri z:") replaced by English, and the new `--delete` branch added. The `*"LINK"*` glob match in the inner loop already matches stow's `UNLINK` verbose-output lines too (no change needed there — `UNLINK` contains `LINK` as a substring).

- [ ] **Step 2: Verify**

Run: `bash -n scripts/setup/symlinks.sh`
Expected: no output.

If available: `shellcheck scripts/setup/symlinks.sh` → no warnings.

Do **not** run this script live (with or without `--delete`) against the real `$HOME` as part of verification — it mutates real symlinks. Code-review the diff instead.

- [ ] **Step 3: Commit**

```bash
git add scripts/setup/symlinks.sh
git commit -m "feat: add --delete flag to symlinks.sh for unstow support"
```

---

### Task 6: Standardize `default-zsh.sh`

**Files:**
- Modify: `scripts/setup/default-zsh.sh`

**Interfaces:**
- None.

- [ ] **Step 1: Rewrite `scripts/setup/default-zsh.sh`**

```bash
#!/usr/bin/env bash
# Install Zsh and set it as the default shell.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Installing and configuring Zsh..."

if ! command -v zsh &>/dev/null; then
    info "Zsh not found. Installing..."
    sudo apt update
    sudo apt install -y zsh
fi

chsh -s "$(command -v zsh)"

success "Zsh installed and set as default shell!"
```

- [ ] **Step 2: Verify**

Run: `bash -n scripts/setup/default-zsh.sh`
Expected: no output.

If available: `shellcheck scripts/setup/default-zsh.sh` → no warnings.

- [ ] **Step 3: Commit**

```bash
git add scripts/setup/default-zsh.sh
git commit -m "style: drop blank comment line, use log.sh in default-zsh.sh"
```

---

### Task 7: Add `Makefile`

**Files:**
- Create: `Makefile`

**Interfaces:**
- Consumes: `./install.sh` (unchanged CLI: no args, `--skip-apt`, `--only-symlinks`), `./scripts/setup/symlinks.sh --delete` (from Task 5).
- Produces: `make help|install|stow|unstow|clean|update|lint` targets, referenced by Task 8's README update.

- [ ] **Step 1: Create `Makefile`**

```makefile
# Makefile — thin entry points over install.sh and the setup scripts.
# Each target is a one-line wrapper; all orchestration logic lives in
# install.sh / scripts/setup/*.sh.

.DEFAULT_GOAL := help

.PHONY: help install stow unstow clean update lint

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*##"}{printf "  %-10s %s\n", $$1, $$2}'

install: ## Full install (apt + installers + stow + default shell)
	./install.sh

stow: ## Symlink configs only (no sudo)
	./install.sh --only-symlinks

unstow: ## Remove symlinks from $$HOME (reversible via `make stow`)
	./scripts/setup/symlinks.sh --delete

clean: unstow ## Alias for unstow

update: ## Re-run installers to update tools/versions (skips apt)
	./install.sh --skip-apt

lint: ## Shellcheck all scripts
	shellcheck install.sh $(shell find scripts -name '*.sh')
```

`$$HOME` and `$$1`/`$$2` use doubled `$` because Make always collapses `$$` to a literal single `$` — required here since these appear in a Makefile (not a recipe line passed straight to the shell).

- [ ] **Step 2: Verify `make help`**

Run: `make help`
Expected output (order matches target declaration order in the file):
```
  help       Show this help
  install    Full install (apt + installers + stow + default shell)
  stow       Symlink configs only (no sudo)
  unstow     Remove symlinks from $HOME (reversible via `make stow`)
  update     Re-run installers to update tools/versions (skips apt)
  lint       Shellcheck all scripts
```
(`clean` has no `##` comment of its own — a bare alias — so it does not appear in `help` output; this is intentional, avoids clutter for a pure alias.)

- [ ] **Step 3: Verify `make lint` runs (result depends on local shellcheck availability)**

Run: `make lint`
Expected: either shellcheck output (fix any reported issues in the relevant task's file, then re-run) or a "command not found" if `shellcheck` isn't installed locally — acceptable at this stage since Task 1 added it to `apt.sh`'s `PACKAGES` for future installs; do not `sudo apt install shellcheck` automatically as part of this plan.

Do **not** run `make install`, `make stow`, `make unstow`, `make update` for verification — they mutate the real system/`$HOME`.

- [ ] **Step 4: Commit**

```bash
git add Makefile
git commit -m "feat: add Makefile with help/install/stow/unstow/update/lint targets"
```

---

### Task 8: Update `README.md`

**Files:**
- Modify: `README.md`

**Interfaces:**
- None (documentation only).

- [ ] **Step 1: Fix the stale apt-packages path reference**

Find (line 54):
```
- Installs apt packages from `scripts/apt-packages.txt` (including `stow`)
```
Replace with:
```
- Installs apt packages from the `PACKAGES` array in `scripts/install/apt.sh` (including `stow`)
```

- [ ] **Step 2: Add `make` equivalents to the Quick Start / Re-running section**

Find (lines 63–67):
```
```bash
./install.sh                  # full
./install.sh --skip-apt       # skip apt step (faster on re-runs)
./install.sh --only-symlinks  # just re-stow (no sudo needed)
```
```
Replace with:
```
```bash
./install.sh                  # full
./install.sh --skip-apt       # skip apt step (faster on re-runs)
./install.sh --only-symlinks  # just re-stow (no sudo needed)
```

Or via `make`: `make install`, `make update` (skip apt), `make stow` (re-stow only),
`make unstow` (remove symlinks), `make lint` (shellcheck). Run `make help` for
the full list.
```

- [ ] **Step 3: Add `Makefile` to the Repo layout tree**

Find (lines 78–79):
```
~/.dotfiles/
├── install.sh                    # Main entry point
```
Replace with:
```
~/.dotfiles/
├── Makefile                      # `make help` for available commands
├── install.sh                    # Main entry point
```

- [ ] **Step 4: Note `--delete` support on symlinks.sh in the Repo layout tree**

Find (line 84):
```
│       ├── symlinks.sh           # Wraps `stow`
```
Replace with:
```
│       ├── symlinks.sh           # Wraps `stow` (supports --delete)
```

- [ ] **Step 5: Add "Installer script template" TOC entry**

Find (lines 16–20):
```
- [Adding a new tool](#adding-a-new-tool)
  - [How to write `path.zsh`](#how-to-write-pathzsh)
  - [File structure](#file-structure)
  - [Lazy-load template](#lazy-load-template)
  - [End-to-end steps](#end-to-end-steps)
```
Replace with:
```
- [Adding a new tool](#adding-a-new-tool)
  - [How to write `path.zsh`](#how-to-write-pathzsh)
  - [File structure](#file-structure)
  - [Lazy-load template](#lazy-load-template)
  - [Installer script template](#installer-script-template)
  - [End-to-end steps](#end-to-end-steps)
```

- [ ] **Step 6: Insert the "Installer script template" section**

Find (end of the "Lazy-load template" section, right before the "End-to-end steps" heading, lines 233–235):
```
Wrappers replace themselves with the real tool on first invocation. Zero startup cost; one-time cost when first used.

### End-to-end steps
```
Replace with:
```
Wrappers replace themselves with the real tool on first invocation. Zero startup cost; one-time cost when first used.

### Installer script template

Every script in `scripts/install/` and `scripts/setup/` follows the same section order:

1. Shebang + one-line purpose comment.
2. `set -euo pipefail`.
3. `DOTFILES_DIR` + `source` block (`scripts/lib/*.sh` helpers, then the tool's `path.zsh` if needed) — each `source` preceded by a `# shellcheck source=` comment.
4. Config array (only if the script has a configurable list), fenced by `# --- Config (edit here) ---` / `# --- end config ---`, placed immediately after the source block.
5. Body — the install logic itself.
6. `success "<tool> installed at $LOCATION"` as the final line.

All output goes through `scripts/lib/log.sh` (`info`/`warning`/`success`/`error`) — never raw `echo`.

Example, with a configurable version list:

```bash
#!/usr/bin/env bash
# Install <tool> and its versions.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../../stow/<tool>/.config/<tool>/path.zsh
source "$DOTFILES_DIR/stow/<tool>/.config/<tool>/path.zsh"

# --- Config (edit here) ---
VERSIONS=(
    "1.2.3"
)
# --- end config ---

info "Installing <tool>..."
for version in "${VERSIONS[@]}"; do
    info "Installing version $version..."
done

success "<tool> installed at $TOOL_HOME"
```

### End-to-end steps
```

- [ ] **Step 7: Update the step-3 code example in "End-to-end steps"**

Find (lines 245–255):
```
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
```
Replace with:
```
```bash
#!/usr/bin/env bash
# Install <tool>.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../lib/git-clone.sh
source "$DOTFILES_DIR/scripts/lib/git-clone.sh"
# shellcheck source=../../stow/<tool>/.config/<tool>/path.zsh
source "$DOTFILES_DIR/stow/<tool>/.config/<tool>/path.zsh"

git_install https://github.com/owner/<tool>.git "$TOOL_HOME"
success "<tool> installed at $TOOL_HOME"
```
```

- [ ] **Step 8: Verify**

Run: `grep -n "apt-packages.txt\|environments.txt" README.md`
Expected: no matches (both stale references removed/updated).

Run: `grep -n "Makefile\|make help\|Installer script template" README.md`
Expected: matches at the new locations from Steps 2, 3, 5, 6.

- [ ] **Step 9: Commit**

```bash
git add README.md
git commit -m "docs: document Makefile and installer script template in README"
```

---

### Task 9: Final verification pass

**Files:** none modified.

**Interfaces:** none.

- [ ] **Step 1: Confirm `install.sh` is untouched**

Run: `git diff main -- install.sh` (or `git log -1 -- install.sh` if already on `main`)
Expected: no changes from this plan touch `install.sh`.

- [ ] **Step 2: Confirm removed files are gone**

Run: `git status --porcelain scripts/install/apt-packages.txt scripts/install/nvm-environments.txt scripts/install/uv-environments.txt`
Expected: no output (files no longer tracked, already committed as deleted in Tasks 1–3).

- [ ] **Step 3: Syntax-check every touched script in one pass**

Run:
```bash
bash -n install.sh Makefile 2>/dev/null; \
for f in scripts/install/*.sh scripts/setup/*.sh; do bash -n "$f" || echo "FAIL: $f"; done
```
Expected: no `FAIL:` lines. (`Makefile` isn't bash — the `bash -n Makefile` in this one-liner is expected to error and is discarded via `2>/dev/null`; only the `scripts/` loop result matters.)

- [ ] **Step 4: Run `make help` and `make lint`**

Run: `make help`
Expected: matches Task 7 Step 2's expected output.

Run: `make lint`
Expected: clean shellcheck run, or a "command not found" if shellcheck isn't installed locally (acceptable — see Task 7 Step 3).

- [ ] **Step 5: Report completion**

Summarize to the user: files changed, files deleted, new `Makefile`, and that `make install`/`stow`/`unstow`/`update` were intentionally never executed during this plan (they mutate the real system) — the user should run them manually to confirm end-to-end behavior on their machine.
