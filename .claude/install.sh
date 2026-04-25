#!/usr/bin/env bash
set -euo pipefail

# Idempotenten installer: simlinka claude config v ~/.claude/

CLAUDE_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Source: $CLAUDE_REPO"
echo "Target: $CLAUDE_DIR"
echo

mkdir -p "$CLAUDE_DIR"

for item in CLAUDE.md settings.json commands agents skills; do
  source="$CLAUDE_REPO/$item"
  target="$CLAUDE_DIR/$item"

  if [[ ! -e "$source" ]]; then
    echo "Skip $item (does not exist in repo)"
    continue
  fi

  ln -sfn "$source" "$target"
  echo "Linked $item"
done

echo
echo "Done. Verify with: ls -la $CLAUDE_DIR"
