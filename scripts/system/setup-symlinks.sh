#!/usr/bin/env bash
#
# Symlink specific dotfiles from the repository to the home directory.

set -e

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }

echo "Dotfiles symlinking setup..."

DOTFILES_DIR="$HOME/.dotfiles"

# Read symlinks from file
SYMLINKS_FILE="$DOTFILES_DIR/scripts/system/symlinks.txt"

if [[ ! -f "$SYMLINKS_FILE" ]]; then
    error "Symlinks file not found: $SYMLINKS_FILE"
    exit 1
fi

# Read each line from the symlinks file
# IFS (Internal Field Separator) set to '=>' to separate source and target
while IFS='=>' read -r src target; do
    # Remove leading/trailing whitespace & removing '>' from target
    src=$(echo "$src" | xargs)
    target="${target#>}"
    target=$(echo "$target" | xargs)

    # Skip empty lines and comments
    if [[ -z "$src" || "$src" == \#* ]]; then
        continue
    fi

    # Expand ~ to $HOME
    target="${target/#\~/$HOME}"

    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Remove existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        rm -f "$target"
    fi

    # Create symlink
    ln -s "$DOTFILES_DIR/$src" "$target"
    info "Linked: $DOTFILES_DIR/$src -> $target"
done < "$SYMLINKS_FILE"

success "All dotfiles symlinked successfully"
