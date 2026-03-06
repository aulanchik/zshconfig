#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE_FILE="$SCRIPT_DIR/.zsh_aliases"
DEST_FILE="$HOME/.zsh_aliases"
ZSHRC="$HOME/.zshrc"
RC_EDIT="$SCRIPT_DIR/.zshrc_edit"

MODE="default"
PROFILES=()
REMOVE_PROFILES=()
DRY_RUN=false
LIST=false
UPDATE=false

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
cat <<EOF
Usage:

  ./setup.sh
  ./setup.sh --profiles=git,brew
  ./setup.sh --profiles=ALL

Options:

  --profiles=<list>     Install specific profiles
  --remove=<list>       Remove profiles
  --update              Rebuild using current profiles
  --list-profiles       Show available profiles
  --dry-run             Preview changes
  --help                Show help

Examples:

  ./setup.sh
  ./setup.sh --profiles=git,brew
  ./setup.sh --profiles=ALL
  ./setup.sh --remove=git
  ./setup.sh --list-profiles
EOF
exit 0
}

# --------------------------------------------------
# Extract available profiles
# --------------------------------------------------

get_profiles() {
grep "^# ---" "$SOURCE_FILE" | sed -E 's/# --- ([a-zA-Z0-9_-]+) ---/\1/'
}

# --------------------------------------------------
# Parse arguments
# --------------------------------------------------

for arg in "$@"; do
case $arg in

--profiles=*)
value="${arg#*=}"
if [[ "$value" == "ALL" ]]; then
MODE="all"
else
MODE="custom"
IFS=',' read -ra PROFILES <<< "$value"
fi
;;

--remove=*)
value="${arg#*=}"
IFS=',' read -ra REMOVE_PROFILES <<< "$value"
;;

--dry-run)
DRY_RUN=true
;;

--update)
UPDATE=true
;;

--list-profiles)
LIST=true
;;

--help|-h)
usage
;;

*)
err "Unknown argument: $arg"
;;

esac
done

# --------------------------------------------------
# Ensure 'general' profile is always included
# --------------------------------------------------

if [[ "$MODE" == "custom" ]]; then
    found=false
    for p in "${PROFILES[@]}"; do
        if [[ "$p" == "general" ]]; then
            found=true
            break
        fi
    done

    if [[ "$found" == false ]]; then
        PROFILES=("general" "${PROFILES[@]}")
    fi
fi

# --------------------------------------------------
# List profiles
# --------------------------------------------------

if $LIST; then
echo -e "${BLUE}Available profiles:${NC}"
get_profiles
exit 0
fi

[[ -f "$SOURCE_FILE" ]] || err ".zsh_aliases template missing"

TMP=$(mktemp)

echo "# Generated on $(date)" > "$TMP"

current=""
include=false

while IFS= read -r line; do

if [[ "$line" =~ ^#\ ---\ ([a-zA-Z0-9_-]+)\ --- ]]; then

section="${BASH_REMATCH[1]}"
include=false

if [[ "$MODE" == "all" ]]; then
include=true
elif [[ "$MODE" == "default" ]]; then
[[ "$section" == "general" ]] && include=true
else
for p in "${PROFILES[@]}"; do
[[ "$p" == "$section" ]] && include=true
done
fi

for r in "${REMOVE_PROFILES[@]}"; do
[[ "$r" == "$section" ]] && include=false
done

if $include; then
echo "" >> "$TMP"
echo "$line" >> "$TMP"
fi

continue
fi

$include && echo "$line" >> "$TMP"

done < "$SOURCE_FILE"

if [[ ! -s "$TMP" ]]; then
err "Resulting alias file empty"
fi

if $DRY_RUN; then
echo -e "${BLUE}Dry run result:${NC}"
cat "$TMP"
rm "$TMP"
exit 0
fi

# --------------------------------------------------
# Backup existing
# --------------------------------------------------

if [[ -f "$DEST_FILE" ]]; then
cp "$DEST_FILE" "$DEST_FILE.backup.$(date +%s)"
warn "Backup created"
fi

mv "$TMP" "$DEST_FILE"

log "Installed aliases → $DEST_FILE"

# --------------------------------------------------
# Ensure zshrc loads aliases
# --------------------------------------------------

SOURCE_LINE='source "$HOME/.zsh_aliases"'

if [[ ! -f "$ZSHRC" ]]; then
touch "$ZSHRC"
fi

if ! grep -qF "$SOURCE_LINE" "$ZSHRC"; then
log "Updating .zshrc"
echo "" >> "$ZSHRC"
cat "$RC_EDIT" >> "$ZSHRC"
else
log ".zshrc already configured"
fi

log "Done!"
echo ""
echo "Run:"
echo "  source ~/.zshrc"
