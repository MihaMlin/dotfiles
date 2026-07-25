#!/usr/bin/env bash
#
# Formats the file Claude just wrote, using the formatter the project already uses.
#
# Runs as a PostToolUse hook on Write|Edit. This config is global, so no formatter can
# be assumed to exist: project-local binaries win over global ones, and a file with no
# available formatter is a silent no-op. A hook that fails would surface as a tool
# error, so every path exits 0.

set -uo pipefail

hook_payload="$(cat)"
target_file="$(jq -r '.tool_response.filePath // .tool_input.file_path // empty' <<<"$hook_payload")"
[[ -f "$target_file" ]] || exit 0

# Nearest ancestor holding a project manifest — that is where local tooling is installed.
find_project_root() {
  local directory="$1"
  while [[ "$directory" != "/" ]]; do
    for manifest in package.json pyproject.toml go.mod Cargo.toml; do
      if [[ -f "$directory/$manifest" ]]; then
        printf '%s' "$directory"
        return 0
      fi
    done
    directory="$(dirname "$directory")"
  done
  return 1
}

project_root="$(find_project_root "$(dirname "$(realpath "$target_file")")" || true)"

# Prints a usable binary path, preferring the project's own install over a global one.
resolve_formatter() {
  local name="$1"
  if [[ -n "$project_root" ]]; then
    for candidate in "$project_root/node_modules/.bin/$name" "$project_root/.venv/bin/$name"; do
      if [[ -x "$candidate" ]]; then
        printf '%s' "$candidate"
        return 0
      fi
    done
  fi
  command -v "$name" 2>/dev/null
}

case "${target_file##*.}" in
  js | jsx | mjs | cjs | ts | tsx | json | jsonc | css | scss | less | html | md | markdown | yaml | yml)
    if formatter="$(resolve_formatter prettier)"; then
      "$formatter" --write --ignore-unknown "$target_file" >/dev/null 2>&1
    fi
    ;;
  py)
    if formatter="$(resolve_formatter ruff)"; then
      "$formatter" format "$target_file" >/dev/null 2>&1
    elif formatter="$(resolve_formatter black)"; then
      "$formatter" --quiet "$target_file" >/dev/null 2>&1
    fi
    ;;
  go)
    if formatter="$(resolve_formatter gofmt)"; then
      "$formatter" -w "$target_file" >/dev/null 2>&1
    fi
    ;;
  rs)
    if formatter="$(resolve_formatter rustfmt)"; then
      "$formatter" "$target_file" >/dev/null 2>&1
    fi
    ;;
  sh | bash | zsh)
    if formatter="$(resolve_formatter shfmt)"; then
      "$formatter" -w "$target_file" >/dev/null 2>&1
    fi
    ;;
  lua)
    if formatter="$(resolve_formatter stylua)"; then
      "$formatter" "$target_file" >/dev/null 2>&1
    fi
    ;;
esac

exit 0
