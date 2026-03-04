#!/bin/bash

# Uninstall script for zsh aliases configuration
# This script removes the aliases setup by setup.sh and cleans up .zshrc
# Author: Artyom Ulanchik

set -e # Exit immediately if a command exits with a non-zero status

ZSHRC_PATH="$HOME/.zshrc"
ALIAS_DEST="$HOME/.zsh_aliases"

SOURCE_PATTERN='source.*\.zsh_aliases'
COMMENT_PATTERN='# Added by setup.sh'

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

log_warn() {
    echo "[WARN] $1" >&2
}

log_success() {
    echo "[SUCCESS] $1"
}

usage() {
    echo "Usage: $0 [--force]"
    echo ""
    echo "Arguments:"
    echo "  --force, -f    Skip confirmation prompts."
    echo ""
    echo "This script will:"
    echo "  1. Remove the sourcing line from ~/.zshrc"
    echo "  2. Delete ~/.zsh_aliases"
    echo "  3. Optionally restore from backup if available"
    exit 0
}

# --- Argument Parsing ---

FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

if [ "$FORCE" = false ]; then
    echo "WARNING: This will remove zsh aliases configuration from your system."
    echo ""
    echo "The following actions will be taken:"
    echo "  - Remove sourcing lines related to .zsh_aliases from $ZSHRC_PATH"
    echo "  - Delete $ALIAS_DEST"
    echo ""
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled."
        exit 0
    fi
fi

log_info "Starting uninstallation..."

# --- Step 1: Clean up .zshrc ---

if [ -f "$ZSHRC_PATH" ]; then
    log_info "Cleaning up $ZSHRC_PATH..."
    
    # Create a backup of .zshrc before modifying it
    RC_CLEANUP_BACKUP="${ZSHRC_PATH}.cleanup_backup.$(date +%Y%m%d_%H%M%S)"
    cp "$ZSHRC_PATH" "$RC_CLEANUP_BACKUP"
    log_info "Created backup of current .zshrc: $(basename "$RC_CLEANUP_BACKUP")"

    # Check if any relevant lines exist
    if grep -qE "$SOURCE_PATTERN|$COMMENT_PATTERN" "$ZSHRC_PATH"; then
        log_info "Removing sourcing logic..."
        
        # Create a temporary file
        TEMP_RC=$(mktemp)
        
        # Use grep -v to invert match (remove lines matching the patterns)
        # -E enables extended regex
        # -v inverts the match (selects lines that DO NOT match)
        grep -vE "$SOURCE_PATTERN|$COMMENT_PATTERN" "$ZSHRC_PATH" > "$TEMP_RC"
        
        # Move the cleaned file back
        mv "$TEMP_RC" "$ZSHRC_PATH"
        
        log_info "Removed sourcing logic from .zshrc"
    else
        log_warn "No matching sourcing logic found in .zshrc. Skipping removal."
    fi
else
    log_warn "$ZSHRC_PATH not found. Skipping .zshrc cleanup."
fi

# --- Step 2: Remove Alias Files ---

files_removed=0

# Remove main alias file
if [ -f "$ALIAS_DEST" ]; then
    rm "$ALIAS_DEST"
    log_info "Deleted $ALIAS_DEST"
    ((files_removed++)) || true
else
    log_warn "$ALIAS_DEST not found."
fi

# Remove any potential profile-specific variants
for f in "$HOME"/.zsh_aliases_*; do
    if [ -f "$f" ]; then
        rm "$f"
        log_info "Deleted $f"
        ((files_removed++)) || true
    fi
done

if [ $files_removed -eq 0 ]; then
    log_warn "No alias files were found to delete."
else
    log_info "Total alias files removed: $files_removed"
fi

# --- Step 3: Restore from Backup (Optional) ---

LATEST_ALIAS_BACKUP=$(ls -t "$HOME"/.zsh_aliases.backup.* 2>/dev/null | head -n 1)

if [ -n "$LATEST_ALIAS_BACKUP" ] && [ -f "$LATEST_ALIAS_BACKUP" ]; then
    echo ""
    log_info "Found existing backup: $(basename "$LATEST_ALIAS_BACKUP")"
    
    RESTORE=false
    if [ "$FORCE" = false ]; then
        read -p "Do you want to restore your previous .zsh_aliases from this backup? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            RESTORE=true
        fi
    else
        log_info "Auto-restore skipped in --force mode. Manual restoration available."
    fi

    if [ "$RESTORE" = true ]; then
        cp "$LATEST_ALIAS_BACKUP" "$ALIAS_DEST"
        log_success "Restored $ALIAS_DEST from backup."
        log_info "Note: You may need to manually add the source line back to .zshrc if you want it active."
    fi
fi

if [ -f "$ZSHRC_PATH" ]; then
    if command -v zsh &> /dev/null; then
        if ! zsh -n "$ZSHRC_PATH" 2>/dev/null; then
            log_error "Warning: .zshrc has syntax errors after cleanup!"
            log_error "Restore from cleanup backup: cp $RC_CLEANUP_BACKUP $ZSHRC_PATH"
        else
            log_info ".zshrc syntax check passed."
        fi
    fi
fi

echo ""
log_success "Uninstallation complete!"
log_info "Please restart your terminal or run 'source $ZSHRC_PATH' to apply changes."
log_info "Backups retained: $(basename "$RC_CLEANUP_BACKUP")"
