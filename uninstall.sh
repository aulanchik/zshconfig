#!/usr/bin/env bash

set -e

ZSHRC="$HOME/.zshrc"
ALIAS_FILE="$HOME/.zsh_aliases"

FORCE=false

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
echo "Usage:"
echo "  ./uninstall.sh [--force]"
echo ""
echo "Options:"
echo "  --force, -f     Skip confirmation"
exit 0
}

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
        err "Unknown option: $1"
        usage
        ;;
esac
done

if [[ "$FORCE" == false ]]; then
echo ""
echo "This will remove:"
echo "  ~/.zsh_aliases"
echo "  sourcing lines from ~/.zshrc"
echo ""

read -p "Continue? (y/N) " -n 1 -r
echo

[[ $REPLY =~ ^[Yy]$ ]] || { log "Cancelled."; exit 0; }
fi

log "Starting uninstall..."

# --------------------------------------------------
# Remove alias file
# --------------------------------------------------

if [[ -f "$ALIAS_FILE" ]]; then
rm "$ALIAS_FILE"
log "Removed $ALIAS_FILE"
else
warn "$ALIAS_FILE not found"
fi

# --------------------------------------------------
# Clean .zshrc
# --------------------------------------------------

if [[ -f "$ZSHRC" ]]; then

BACKUP="$ZSHRC.backup.$(date +%s)"
cp "$ZSHRC" "$BACKUP"

log "Backup created: $BACKUP"

TMP=$(mktemp)

grep -vF 'source "$HOME/.zsh_aliases"' "$ZSHRC" \
| grep -vF '[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"' \
> "$TMP"

mv "$TMP" "$ZSHRC"

log "Removed alias sourcing from .zshrc"

else
warn ".zshrc not found"
fi

LATEST_BACKUP=$(ls -t "$HOME"/.zsh_aliases.backup.* 2>/dev/null | head -n1)

if [[ -n "$LATEST_BACKUP" && "$FORCE" == false ]]; then

echo ""
log "Found backup: $(basename "$LATEST_BACKUP")"

read -p "Restore it? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
cp "$LATEST_BACKUP" "$ALIAS_FILE"
log "Backup restored"
fi

fi

if command -v zsh >/dev/null 2>&1 && [[ -f "$ZSHRC" ]]; then
if zsh -n "$ZSHRC" 2>/dev/null; then
log ".zshrc syntax OK"
else
warn ".zshrc syntax issue detected"
warn "Restore with:"
echo "cp $BACKUP $ZSHRC"
fi
fi

echo ""
log "Uninstall complete"
echo "Run:"
echo "  source ~/.zshrc"
