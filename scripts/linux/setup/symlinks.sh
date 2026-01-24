#!/usr/bin/env bash
#
# Symlink specific dotfiles from the repository to the home directory.
# Supports backup of existing files and dry-run mode.
#
# Usage: setup-symlinks.sh [-n|--dry-run] [-v|--verbose] [-f|--force]
#   -n, --dry-run   Show what would be done without making changes
#   -v, --verbose   Show detailed output
#   -f, --force     Skip backup and overwrite existing files

set -e

# =============================================================================
# Configuration
# =============================================================================

DOTFILES_DIR="$HOME/.dotfiles"
SYMLINKS_FILE="$DOTFILES_DIR/scripts/linux/symlinks.txt"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

DRY_RUN=false
VERBOSE=false
FORCE=false

# =============================================================================
# Helper Functions
# =============================================================================

error()   { echo "❌ $1"; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }
debug()   { [[ "$VERBOSE" == true ]] && echo "   $1"; }

usage() {
    echo "Usage: $(basename "$0") [-n|--dry-run] [-v|--verbose] [-f|--force]"
    echo "  -n, --dry-run   Show what would be done without making changes"
    echo "  -v, --verbose   Show detailed output"
    echo "  -f, --force     Skip backup and overwrite existing files"
    exit 1
}

backup_file() {
    local file="$1"
    if [[ "$FORCE" == true ]]; then
        debug "Force mode: skipping backup of $file"
        return 0
    fi

    if [[ ! -d "$BACKUP_DIR" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            debug "Would create backup directory: $BACKUP_DIR"
        else
            mkdir -p "$BACKUP_DIR"
            debug "Created backup directory: $BACKUP_DIR"
        fi
    fi

    local backup_path="$BACKUP_DIR/$(basename "$file")"
    if [[ "$DRY_RUN" == true ]]; then
        debug "Would backup: $file -> $backup_path"
    else
        cp -L "$file" "$backup_path" 2>/dev/null || cp "$file" "$backup_path"
        debug "Backed up: $file -> $backup_path"
    fi
}

create_symlink() {
    local src="$1"
    local target="$2"

    # Create target directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            debug "Would create directory: $target_dir"
        else
            mkdir -p "$target_dir"
        fi
    fi

    # Handle existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        # Check if it's already correctly linked
        if [[ -L "$target" && "$(readlink "$target")" == "$DOTFILES_DIR/$src" ]]; then
            debug "Already linked correctly: $target"
            return 0
        fi

        # Backup existing file (if it's a real file, not a symlink)
        if [[ -f "$target" && ! -L "$target" ]]; then
            backup_file "$target"
        fi

        if [[ "$DRY_RUN" == true ]]; then
            debug "Would remove: $target"
        else
            rm -f "$target"
        fi
    fi

    # Create symlink
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY-RUN] Would link: $src -> $target"
    else
        ln -s "$DOTFILES_DIR/$src" "$target"
        info "Linked: $src -> $target"
    fi
}

# =============================================================================
# Parse Arguments
# =============================================================================

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=true; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -f|--force)   FORCE=true; shift ;;
        -h|--help)    usage ;;
        *)            echo "Unknown option: $1"; usage ;;
    esac
done

# =============================================================================
# Main
# =============================================================================

echo "Dotfiles symlinking setup..."
[[ "$DRY_RUN" == true ]] && warning "Dry-run mode: no changes will be made"

if [[ ! -f "$SYMLINKS_FILE" ]]; then
    error "Symlinks file not found: $SYMLINKS_FILE"
    exit 1
fi

# Read each line from the symlinks file
while IFS='=>' read -r src target || [[ -n "$src" ]]; do
    # Remove leading/trailing whitespace & remove '>' from target
    src=$(echo "$src" | xargs)
    target="${target#>}"
    target=$(echo "$target" | xargs)

    # Skip empty lines and comments
    if [[ -z "$src" || "$src" == \#* ]]; then
        continue
    fi

    # Expand ~ to $HOME
    target="${target/#\~/$HOME}"

    create_symlink "$src" "$target"
done < "$SYMLINKS_FILE"

if [[ "$DRY_RUN" == true ]]; then
    success "Dry-run complete. No changes were made."
else
    success "All dotfiles symlinked successfully"
    [[ -d "$BACKUP_DIR" ]] && info "Backups saved to: $BACKUP_DIR"
fi
