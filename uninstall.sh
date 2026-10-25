#!/usr/bin/env bash
# Removes every symlink in ~/.zsh_aliases.d/ and the loader block from ~/.zshrc.
# A timestamped backup of ~/.zshrc is made first.
set -euo pipefail

TARGET_DIR="$HOME/.zsh_aliases.d"
ZSHRC="$HOME/.zshrc"
MARK_START="# >>> zshconfig >>>"
MARK_END="# <<< zshconfig <<<"

if [[ "${1:-}" != "--force" ]]; then
  read -r -p "Remove zshconfig aliases and loader from $ZSHRC? [y/N] " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] || { echo "Aborted."; exit 0; }
fi

# 1. Remove profile symlinks (only symlinks, never regular files).
if [[ -d "$TARGET_DIR" ]]; then
  for link in "$TARGET_DIR"/*.zsh; do
    [[ -L "$link" ]] && rm "$link"
  done
  rmdir "$TARGET_DIR" 2>/dev/null || echo "Kept $TARGET_DIR (it still contains other files)."
fi

# 2. Remove the loader block from ~/.zshrc.
if [[ -f "$ZSHRC" ]] && grep -qF "$MARK_START" "$ZSHRC"; then
  cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d%H%M%S)"
  tmp="$(mktemp)"
  awk -v s="$MARK_START" -v e="$MARK_END" '
    $0 == s { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip
  ' "$ZSHRC" > "$tmp"
  cat "$tmp" > "$ZSHRC"   # cat keeps the original file's permissions and symlink
  rm "$tmp"
  echo "Removed loader block from $ZSHRC (backup saved next to it)."
fi

echo "Done. Restart your terminal."
