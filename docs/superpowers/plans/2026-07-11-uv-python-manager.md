# Replace pyenv with uv Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `pyenv` with `uv` as this dotfiles repo's Python version manager, so a fresh machine gets Python without any build toolchain.

**Architecture:** Add a new `uv` stow package (`path.zsh` declaring uv's install-location env vars) and a new `scripts/install/uv.sh` installer that installs the `uv` binary via its official shell installer (PATH/rc untouched — this repo owns that) and then installs a declared set of Python versions with `uv python install`, mirroring the existing `label:version` file format. Cut `install.sh` over to it, update aliases and docs, then delete all pyenv artifacts.

**Tech Stack:** Bash (`set -euo pipefail`), zsh (`path.zsh` convention), `uv` (https://docs.astral.sh/uv/), GNU Stow.

## Global Constraints

- Installer must not modify shell rc files (`.zshrc`, `.bashrc`, etc.) — set `UV_NO_MODIFY_PATH=1` when running uv's installer.
- Installer must be idempotent (safe to re-run), matching every other script in `scripts/install/`.
- Directory locations must respect XDG conventions already established in `.zshrc` (`XDG_DATA_HOME`, `BIN_HOME`), consistent with how pyenv/nvm/fzf do it today.
- No new system-wide build dependencies introduced.
- Only `pyenv`-related files/config are touched. `nvm`, `fzf`, `zinit`, and unrelated `apt-packages.txt` / `README.md` content stay untouched.
- `python3`/`python3-pip` stay in `apt-packages.txt` Essentials (out of scope for removal).

---

### Task 1: uv stow package (`path.zsh`) and Python-version declaration file

**Files:**
- Create: `stow/uv/.config/uv/path.zsh`
- Create: `scripts/install/uv-environments.txt`

**Interfaces:**
- Produces: env vars `UV_INSTALL_DIR`, `UV_PYTHON_BIN_DIR`, `UV_PYTHON_INSTALL_DIR`, `UV_TOOL_DIR` — consumed by Task 2's `uv.sh` and by the `uv` binary itself at runtime.
- Produces: `scripts/install/uv-environments.txt`, same `label:version` line format as the old `pyenv-environments.txt` — consumed by Task 2's `uv.sh`.

- [ ] **Step 1: Create `stow/uv/.config/uv/path.zsh`**

```zsh
# uv — Python package/version manager
export UV_INSTALL_DIR="$HOME/.local/bin"
export UV_PYTHON_BIN_DIR="$HOME/.local/bin"
export UV_PYTHON_INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/uv/python"
export UV_TOOL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/uv/tools"
```

No bash-safety guard and no zsh region: unlike `pyenv`/`nvm`, uv has no `eval $(... init -)` shell hook and its defaults already land in `$BIN_HOME` (already on `$PATH` via `.zshrc`) — this file exists purely to name uv's data locations explicitly (rule 6: installers must source `path.zsh`, never hardcode).

- [ ] **Step 2: Verify syntax**

Run: `zsh -n stow/uv/.config/uv/path.zsh && bash -n stow/uv/.config/uv/path.zsh && echo OK`
Expected: `OK`

- [ ] **Step 3: Create `scripts/install/uv-environments.txt`**

```
# --- uv-managed Python versions to install ---
# --- Format is purpose_label:version_number ---

default:3.10.13
deep_learning:3.11.7
web_api:3.12.1
```

(Same versions as the old `pyenv-environments.txt` — this is a mechanical port, not a version bump.)

- [ ] **Step 4: Commit**

```bash
git add stow/uv/.config/uv/path.zsh scripts/install/uv-environments.txt
git commit -m "feat: add uv stow package and python-version declaration file"
```

---

### Task 2: `scripts/install/uv.sh` installer

**Files:**
- Create: `scripts/install/uv.sh`

**Interfaces:**
- Consumes: `stow/uv/.config/uv/path.zsh` (Task 1) for `UV_INSTALL_DIR`; `scripts/install/uv-environments.txt` (Task 1) for versions; `scripts/lib/log.sh` (`info`, `warning`, `success` — already defined, existing file, unchanged).
- Produces: `uv` binary on `$UV_INSTALL_DIR`; installed Python versions; a default `python`/`python3` on `$PATH`. Consumed by Task 3 (`install.sh` cutover) and Task 7 (final verification).

- [ ] **Step 1: Write `scripts/install/uv.sh`**

```bash
#!/usr/bin/env bash
#
# Install uv and Python versions listed in uv-environments.txt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"
# shellcheck source=../../stow/uv/.config/uv/path.zsh
source "$DOTFILES_DIR/stow/uv/.config/uv/path.zsh"

if command -v uv &>/dev/null; then
    info "uv already installed."
else
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

# Make uv callable for the rest of this script, even on first install.
export PATH="$UV_INSTALL_DIR:$PATH"

env_file="$DOTFILES_DIR/scripts/install/uv-environments.txt"
if [[ ! -f "$env_file" ]]; then
    warning "$env_file not found. Skipping Python version installation."
    success "uv installed at $UV_INSTALL_DIR"
    exit 0
fi

info "Reading versions from $env_file..."
versions=$(grep -v '^#' "$env_file" | grep -v '^$' | cut -d':' -f2 | sort -u)

for version in $versions; do
    info "Installing Python $version..."
    # uv python install is idempotent (no-ops if already present) —
    # unlike pyenv.sh, no pre-check is needed here.
    uv python install "$version"
done

first_version=$(grep -v '^#' "$env_file" | grep -v '^$' | head -1 | cut -d':' -f2)
if [[ -n "$first_version" ]]; then
    uv python install "$first_version" --default
    uv python pin --global "$first_version"
    info "Global Python set to $first_version"
fi

success "uv installed at $UV_INSTALL_DIR"
```

- [ ] **Step 2: Make it executable and verify syntax**

Run: `chmod +x scripts/install/uv.sh && bash -n scripts/install/uv.sh && echo OK`
Expected: `OK`

- [ ] **Step 3: Run it for real and verify**

This installs `uv` and the three declared Python versions onto this machine, under `~/.local/bin` and `~/.local/share/uv/` — that's the actual deliverable, not a mock.

Run:
```bash
DOTFILES_DIR="$(pwd)" bash scripts/install/uv.sh
export PATH="$HOME/.local/bin:$PATH"
uv --version
python --version
uv python list --only-installed
```
Expected: `uv --version` prints a version string; `python --version` prints `Python 3.10.13`; `uv python list --only-installed` lists all three installed versions (3.10.13, 3.11.7, 3.12.1).

- [ ] **Step 4: Re-run to confirm idempotency**

Run: `DOTFILES_DIR="$(pwd)" bash scripts/install/uv.sh`
Expected: exits 0, logs `uv already installed.` and re-affirms each Python version without erroring (uv prints its own "already installed"/no-op messaging).

- [ ] **Step 5: Commit**

```bash
git add scripts/install/uv.sh
git commit -m "feat: add uv installer script"
```

---

### Task 3: Cut `install.sh` over to `uv.sh`

**Files:**
- Modify: `install.sh:28`

**Interfaces:**
- Consumes: `scripts/install/uv.sh` (Task 2).

- [ ] **Step 1: Edit the `STEPS` array**

In `install.sh`, change:
```bash
    "scripts/install/pyenv.sh"      # Python Version Manager
```
to:
```bash
    "scripts/install/uv.sh"         # Python Version Manager (uv)
```

- [ ] **Step 2: Verify syntax**

Run: `bash -n install.sh && echo OK`
Expected: `OK`

- [ ] **Step 3: Verify the step list resolves correctly**

Run: `grep -n 'scripts/install' install.sh`
Expected: output includes `scripts/install/uv.sh` and does **not** include `scripts/install/pyenv.sh`.

- [ ] **Step 4: Commit**

```bash
git add install.sh
git commit -m "feat: wire uv installer into install.sh"
```

---

### Task 4: Update shell aliases

**Files:**
- Modify: `stow/zsh/.config/zsh/20-aliases.zsh:44-50`

- [ ] **Step 1: Replace the pyenv alias block**

Change:
```zsh
# Pyenv
alias py='python'
alias pyenv-ls='pyenv versions'
alias pyenv-i='pyenv install'
alias pyenv-list='pyenv install --list | grep -E "^\s*3\.(1[0-9]|[0-9])\.[0-9]+$"'
alias pyenv-g='pyenv global'
alias pyenv-s='pyenv shell'
```
to:
```zsh
# uv
alias py='python'
alias uv-ls='uv python list --only-installed'
alias uv-i='uv python install'
alias uv-list='uv python list --all-versions'
alias uv-g='uv python pin --global'
```

(`pyenv-s`/`pyenv shell` has no direct uv equivalent — per-shell version overrides aren't part of uv's model — so it's dropped rather than mapped to something misleading.)

- [ ] **Step 2: Verify syntax**

Run: `zsh -n stow/zsh/.config/zsh/20-aliases.zsh && echo OK`
Expected: `OK`

- [ ] **Step 3: Verify no leftover pyenv aliases**

Run: `grep -in pyenv stow/zsh/.config/zsh/20-aliases.zsh`
Expected: no output (exit code 1).

- [ ] **Step 4: Commit**

```bash
git add stow/zsh/.config/zsh/20-aliases.zsh
git commit -m "feat: replace pyenv aliases with uv equivalents"
```

---

### Task 5: Drop pyenv's build-dependency apt packages

**Files:**
- Modify: `scripts/install/apt-packages.txt:16-29`

- [ ] **Step 1: Remove the pyenv build-dependency block**

Change:
```
python3-pip
stow
tmux
unzip
vim
wget
zsh

# --- Python build dependencies for pyenv ---
libbz2-dev
libssl-dev
libffi-dev
libreadline-dev
libsqlite3-dev
libncurses5-dev
libncursesw5-dev
xz-utils
tk-dev
zlib1g-dev
liblzma-dev
uuid-dev

# --- Useful ---
```
to:
```
python3-pip
stow
tmux
unzip
vim
wget
zsh

# --- Useful ---
```

`build-essential`/`cmake` stay under `# --- Essentials ---` — they're general-purpose, not pyenv-specific. `python3`/`python3-pip` stay too (out of scope per the spec).

- [ ] **Step 2: Verify the block is gone and essentials are intact**

Run: `grep -in pyenv scripts/install/apt-packages.txt; grep -c '^python3' scripts/install/apt-packages.txt`
Expected: first command has no output (exit 1); second prints `2`.

- [ ] **Step 3: Commit**

```bash
git add scripts/install/apt-packages.txt
git commit -m "chore: drop pyenv build dependencies from apt package list"
```

---

### Task 6: Update README.md

**Files:**
- Modify: `README.md:90` (repo layout tree)
- Modify: `README.md:118` (worked-example sentence)
- Modify: `README.md:172-177` (Category 2 table)
- Modify: `README.md:185` (path.zsh rule 1 example)
- Modify: `README.md:274` (Conventions bullet)

- [ ] **Step 1: Repo layout tree (line 90)**

Change:
```
    ├── pyenv/                    # → ~/.config/pyenv/path.zsh
```
to:
```
    ├── uv/                       # → ~/.config/uv/path.zsh
```

- [ ] **Step 2: Worked-example sentence (line 118)**

Change:
```
Take `zinit` as a worked example. The same pattern applies to every shell-extension tool (`nvm`, `pyenv`, `fzf`).
```
to:
```
Take `zinit` as a worked example. The same pattern applies to every shell-extension tool (`nvm`, `uv`, `fzf`).
```

- [ ] **Step 3: Category 2 table (lines 172-177) — replace the pyenv row and add a clarifying sentence**

Change:
```
| Tool    | Var              | What `path.zsh`does                                                                        |
| ------- | ---------------- |--------------------------------------------------------------------------------------------|
| `zinit` | `ZINIT_HOME`     | Sources `zinit.zsh` to register the plugin manager.                                        |
| `nvm`   | `NVM_DIR`        | Defines lazy wrappers for `nvm`/`node`/`npm`/`npx`.                                        |
| `pyenv` | `PYENV_ROOT`     | Prepends `bin/` and `shims/` to `$PATH`; defines lazy wrappers for `pyenv`/`python`/`pip`. |
| `fzf`   | —                | Currently no `path.zsh` (fzf installer writes its own shell init via `--xdg`)              |
```
to:
```
| Tool    | Var              | What `path.zsh`does                                                                        |
| ------- | ---------------- |--------------------------------------------------------------------------------------------|
| `zinit` | `ZINIT_HOME`     | Sources `zinit.zsh` to register the plugin manager.                                        |
| `nvm`   | `NVM_DIR`        | Defines lazy wrappers for `nvm`/`node`/`npm`/`npx`.                                        |
| `uv`    | `UV_PYTHON_INSTALL_DIR` | Declares install-location env vars only — no `$PATH` edits or lazy wrappers needed. |
| `fzf`   | —                | Currently no `path.zsh` (fzf installer writes its own shell init via `--xdg`)              |
```

Then, immediately after the table, add:

```
`uv` is a partial exception: it still needs `path.zsh` (rule 6 below) to declare where uv keeps its data, but it has no expensive shell-init to defer, so it skips the lazy-wrapper machinery `nvm` needs — its binary and `python`/`python3` shims already land in `$BIN_HOME`.
```

- [ ] **Step 4: path.zsh rule 1 example (line 185)**

Change:
```
1. **Use the tool's official env var name** — whatever the tool itself reads. `ZINIT_HOME` for zinit, `NVM_DIR` for nvm, `PYENV_ROOT` for pyenv. Don't invent names; if you set `NVM_ROOT`, the nvm runtime won't see it.
```
to:
```
1. **Use the tool's official env var name** — whatever the tool itself reads. `ZINIT_HOME` for zinit, `NVM_DIR` for nvm, `UV_PYTHON_INSTALL_DIR`/`UV_TOOL_DIR` for uv. Don't invent names; if you set `NVM_ROOT`, the nvm runtime won't see it.
```

- [ ] **Step 5: Conventions bullet (line 274)**

Change:
```
- **Performance**: lazy-loading for `nvm` and `pyenv`; `zinit` runs plugins in turbo mode. Target startup: <300ms.
```
to:
```
- **Performance**: lazy-loading for `nvm`; `zinit` runs plugins in turbo mode; `uv` has no shell-init to defer. Target startup: <300ms.
```

- [ ] **Step 6: Verify no leftover pyenv references**

Run: `grep -in pyenv README.md`
Expected: no output (exit code 1).

- [ ] **Step 7: Commit**

```bash
git add README.md
git commit -m "docs: replace pyenv references with uv"
```

---

### Task 7: Remove pyenv artifacts and final verification

**Files:**
- Delete: `scripts/install/pyenv.sh`
- Delete: `scripts/install/pyenv-environments.txt`
- Delete: `stow/pyenv/` (entire directory, including `stow/pyenv/.config/pyenv/path.zsh`)

- [ ] **Step 1: Delete the files**

```bash
git rm scripts/install/pyenv.sh scripts/install/pyenv-environments.txt
git rm -r stow/pyenv
```

- [ ] **Step 2: Repo-wide check for leftover references**

Run: `grep -rin pyenv . --include='*.sh' --include='*.zsh' --include='*.md' --include='*.txt' | grep -v '^./.git/'`
Expected: no output (exit code 1) — confirms Tasks 4–6 and this deletion caught every reference.

- [ ] **Step 3: Full symlink + installer smoke test**

```bash
./install.sh --only-symlinks
ls -la ~/.config/uv/path.zsh
```
Expected: `install.sh --only-symlinks` completes without error; `~/.config/uv/path.zsh` is a symlink into the repo's `stow/uv/.config/uv/path.zsh`; there is no `~/.config/pyenv` left over (stow removed it when the package was deleted — if it still exists, `stow -D` it manually: `cd stow && stow -D pyenv`).

- [ ] **Step 4: Fresh shell sanity check**

```bash
zsh -lc 'command -v uv && command -v python && python --version'
```
Expected: both commands resolve, `python --version` prints `Python 3.10.13`.

- [ ] **Step 5: Commit**

```bash
git commit -m "chore: remove pyenv artifacts, uv is now the Python version manager"
```

---

## Self-Review Notes

- **Spec coverage:** every "Required functionality" bullet from the spec maps to a task — install uv (Task 2), install declared versions + systemwide default (Task 2), stow integration (Task 1), aliases (Task 4), remove pyenv entirely (Task 7), remove pyenv-only build deps (Task 5). "Edge cases" (idempotent re-run, missing env file, `--skip-apt` still works) are covered by Task 2 Steps 3–4 and the `uv.sh` logic itself (env-file existence check mirrors `pyenv.sh`/`nvm.sh`).
- **Placeholder scan:** no TBD/TODO; every step has literal file content or an exact command with expected output.
- **Type/name consistency:** `UV_INSTALL_DIR` / `UV_PYTHON_BIN_DIR` / `UV_PYTHON_INSTALL_DIR` / `UV_TOOL_DIR` are defined once in Task 1 and used with identical names in Task 2 and Task 6's docs — no drift.
