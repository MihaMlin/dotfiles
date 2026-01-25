#!/usr/bin/env bash
#
# Simple symlink setup for dotfiles.
# Always verbose. Overwrites existing links.

set -e

# Configuration
DOTFILES_DIR="$HOME/.dotfiles"
SYMLINKS_FILE="$DOTFILES_DIR/scripts/symlinks.txt"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

echo -e "\033[0;34mℹ️ Starting dotfiles symlinking...\033[0m"

# Ensure symlinks file exists
if [[ ! -f "$SYMLINKS_FILE" ]]; then
    echo "❌ Error: $SYMLINKS_FILE not found."
    exit 1
fi

# Process each line
while IFS='=>' read -r src target || [[ -n "$src" ]]; do
    # Cleanup whitespace and comments
    src=$(echo "$src" | xargs)
    target=$(echo "${target#>}" | xargs)
    [[ -z "$src" || "$src" == \#* ]] && continue

    # Expand ~ and prepare full paths
    target_path="${target/#\~/$HOME}"
    src_path="$DOTFILES_DIR/$src"

    # 1. Create target parent directory if missing
    mkdir -p "$(dirname "$target_path")"

    # 2. Backup if it's a real file (not a symlink)
    if [[ -f "$target_path" && ! -L "$target_path" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -L "$target_path" "$BACKUP_DIR/"
        echo "⚠️  Backed up existing file: $(basename "$target_path")"
    fi

    # 3. Create Symlink (v=verbose, f=force/overwrite, s=symbolic)
    ln -sfv "$src_path" "$target_path"

done < "$SYMLINKS_FILE"

echo -e "\033[0;32m✅ Symlinking complete.\033[0m"
[[ -d "$BACKUP_DIR" ]] && echo "ℹ️  Backups located in: $BACKUP_DIR"
