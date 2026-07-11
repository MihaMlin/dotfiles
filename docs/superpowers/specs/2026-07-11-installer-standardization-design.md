# Design: Standardize installer scripts, add Makefile

Date: 2026-07-11
Status: Approved by user, pending implementation plan

## Goal

Refactor `scripts/install/*.sh` (and the two `scripts/setup/*.sh` scripts) so
every installer follows one fixed section order and one config convention,
and add a `Makefile` as a thin, discoverable entry point over the existing
`install.sh`.

Success criteria:
- Every file in `scripts/install/` and `scripts/setup/` has the same section
  order: shebang + purpose comment → `set -euo pipefail` → `DOTFILES_DIR` +
  `source` block → (optional) config array → body → `success` message.
- No installer reads a sidecar `.txt` file for its configurable list
  (versions, packages) — each declares its own bash array inline.
- `make help|install|stow|unstow|clean|update|lint` all work and map to
  existing (or minimally extended) scripts — no orchestration logic is
  duplicated between `Makefile` and `install.sh`.
- `./install.sh` and `./install.sh --skip-apt` / `--only-symlinks` behave
  exactly as before (no interface change, no regression).

## Required functionality

### Installer template
Every script in `scripts/install/` and `scripts/setup/` follows this section
order:
1. `#!/usr/bin/env bash` + one-line purpose comment.
2. `set -euo pipefail`.
3. `DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"` + `source` of whichever
   `scripts/lib/*.sh` helpers and `stow/<tool>/.config/<tool>/path.zsh` the
   script needs, each with a `# shellcheck source=` comment.
4. Config array, only for scripts that have a configurable list, delimited by
   `# --- Config (edit here) ---` / `# --- end config ---` comments, placed
   immediately after the source block.
5. Body: the actual install logic.
6. `success "<tool> installed at $LOCATION"` as the final line of output.

All output uses `scripts/lib/log.sh` helpers (`info`/`warning`/`success`/
`error`) — no raw `echo`. All messages are in English.

### Config arrays replace sidecar files
- `scripts/install/apt.sh`: `PACKAGES=(...)` array replaces
  `scripts/install/apt-packages.txt`.
- `scripts/install/nvm.sh`: `VERSIONS=(...)` array replaces
  `scripts/install/nvm-environments.txt`.
- `scripts/install/uv.sh`: `VERSIONS=(...)` array replaces
  `scripts/install/uv-environments.txt`. Each entry may carry a trailing
  `# label` comment (documentation only, not parsed). The first array entry
  is the one set as the global default (same rule as today's "first line of
  the file").
- All three `*-environments.txt` / `apt-packages.txt` files are deleted.
- Loop logic simplifies accordingly (no file reads, no `grep`/`cut`
  parsing) — a plain `for x in "${ARRAY[@]}"; do ... done`.
- The "missing env file → warn and skip" fallback path is removed: the array
  is now part of the script itself, so it cannot be "missing".

### Bug fixes / consistency fixes (surfaced during exploration)
- `scripts/install/nvm.sh` calls `warn` (undefined — `log.sh` only defines
  `warning`). Fix to `warning`.
- `scripts/setup/symlinks.sh` uses raw `echo` and a Slovenian string
  ("Preveri z:") — replace with `info`/`success` and English text.
- `scripts/setup/default-zsh.sh` uses raw `echo` for its opening message —
  replace with `info`.

### Makefile
New `Makefile` at repo root, `help` as `.DEFAULT_GOAL`:

| Target    | Behavior                                              |
|-----------|--------------------------------------------------------|
| `help`    | Self-documenting target list (parses `##` comments)    |
| `install` | `./install.sh` (full install)                          |
| `stow`    | `./install.sh --only-symlinks`                         |
| `unstow`  | `./scripts/setup/symlinks.sh --delete`                 |
| `clean`   | Alias for `unstow`                                     |
| `update`  | `./install.sh --skip-apt`                              |
| `lint`    | `shellcheck install.sh scripts/**/*.sh`                |

The Makefile contains no orchestration logic of its own — every target is a
one-line call into an existing or minimally-extended script.

### `symlinks.sh --delete`
`scripts/setup/symlinks.sh` gains a `--delete` flag that runs
`stow --dir="$STOW_DIR" --target="$HOME" --delete` per package (mirroring the
existing per-package loop) instead of `--restow --adopt`. This is the only
new script capability introduced by this design; everything else is
reordering/renaming existing logic.

### Documentation
`README.md` is updated:
- Quick Start section gains the `make` command equivalents alongside the
  existing `./install.sh` commands.
- "Adding a new tool" section gains the installer template contract
  (section order, config array convention) as a companion to the existing
  `path.zsh` guidance.
- References to the now-deleted `*-environments.txt` / `apt-packages.txt`
  files are updated to describe the inline array convention instead.

## Constraints

- No new external dependencies (`make` and `shellcheck` are assumed
  available or apt-installable; `shellcheck` is not added to
  `scripts/install/apt-packages.txt`'s replacement `PACKAGES` array unless it
  is already a listed package — confirm during planning).
- `install.sh`'s own CLI surface (`--skip-apt`, `--only-symlinks`, `-h`)
  does not change.
- No change to `stow/` package contents, `vscode/`, or `docs/` beyond the
  spec/plan documents this process itself produces.
- No change to how `neovim.sh`, `zinit.sh`, `fzf.sh` install their tools —
  only reordering to match the template, not behavior changes.
- Follow existing repo conventions: `DOTFILES_DIR`-relative paths, XDG
  locations untouched, `scripts/lib/log.sh` as the only output mechanism.

## Edge cases

- `uv.sh`'s "first array entry becomes global default" must still work when
  the array has exactly one entry.
- `make unstow` / `symlinks.sh --delete` must not error if a package was
  never stowed (stow's `--delete` on an already-absent link is a no-op).
- `make lint` must exit non-zero if shellcheck reports any issue, so it is
  usable as a pre-commit gate later (not wired into a git hook now — out of
  scope).
- Re-running `make install` / `make update` must remain idempotent, matching
  current `install.sh` behavior — no installer's behavior changes, only its
  config source (array vs. file).

## Non-goals

- Not building a declarative manifest / generic runner (rejected Approach C)
  — each installer stays an explicit, independently-readable script.
- Not adding a shared helper function to reduce the nvm.sh/uv.sh loop
  duplication (rejected Approach B) — would make those two scripts diverge
  in shape from the rest.
- Not adding a `make clean` that removes installed tools / git clones from
  `$XDG_DATA_HOME` — explicitly scoped to unstow (symlinks) only; destructive
  tool removal is out of scope.
- Not restructuring `stow/` package layout, `vscode/`, or `docs/` content.
- Not wiring `lint` into a git pre-commit hook.
- Not changing `scripts/lib/*.sh` (`log.sh`, `git-clone.sh`,
  `preflight.sh`) — already consistent, no template violations found there.
