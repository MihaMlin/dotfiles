#!/usr/bin/env bash
set -euo pipefail

# Idempotent installer: symlinks Claude config into ~/.claude/

CLAUDE_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
ITEMS=(CLAUDE.md settings.json commands agents skills)

echo "Source: $CLAUDE_REPO"
echo "Target: $CLAUDE_DIR"
echo

mkdir -p "$CLAUDE_DIR"

for item in "${ITEMS[@]}"; do
    source="$CLAUDE_REPO/$item"
    target="$CLAUDE_DIR/$item"

    if [[ ! -e "$source" ]]; then
        echo "Skip $item (does not exist in repo)"
        continue
    fi

    # If target exists and is not a symlink, refuse — likely real user data.
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Skip $item (target exists and is not a symlink: $target)"
        echo "  Move it aside manually if you want to replace it."
        continue
    fi

    ln -sfn "$source" "$target"
    echo "Linked $item"
done

echo
echo "Done. Verify with: ls -la $CLAUDE_DIR"
