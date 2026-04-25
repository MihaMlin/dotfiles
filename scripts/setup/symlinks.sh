#!/usr/bin/env bash
#
# Symlink setup for dotfiles.
# Always verbose. Overwrites existing symlinks, backs up real files.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
SYMLINKS_FILE="$DOTFILES_DIR/scripts/symlinks.txt"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/scripts/lib/log.sh"

info "Starting dotfiles symlinking..."

if [[ ! -f "$SYMLINKS_FILE" ]]; then
    error "$SYMLINKS_FILE not found."
    exit 1
fi

while IFS='=>' read -r src target || [[ -n "$src" ]]; do
    # Cleanup whitespace and skip comments/blank lines
    src=$(echo "$src" | xargs)
    target=$(echo "${target#>}" | xargs)
    [[ -z "$src" || "$src" == \#* ]] && continue

    # Expand ~ and resolve full paths
    target_path="${target/#\~/$HOME}"
    src_path="$DOTFILES_DIR/$src"

    # Create target parent directory if missing
    mkdir -p "$(dirname "$target_path")"

    # Backup if it's a real file (not already a symlink)
    if [[ -f "$target_path" && ! -L "$target_path" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -L "$target_path" "$BACKUP_DIR/"
        warning "Backed up existing file: $(basename "$target_path")"
    fi

    # Create symlink (s=symbolic, f=force/overwrite, v=verbose)
    ln -sfv "$src_path" "$target_path"

done < "$SYMLINKS_FILE"

success "Symlinking complete."
[[ -d "$BACKUP_DIR" ]] && info "Backups located in: $BACKUP_DIR"
