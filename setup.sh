#!/usr/bin/env bash
# Installs zsh alias profiles by symlinking them into ~/.zsh_aliases.d/
# and adding a small loader block to ~/.zshrc.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.zsh_aliases.d"
ZSHRC="$HOME/.zshrc"
MARK_START="# >>> zshconfig >>>"

PROFILES=""
REMOVE=""
LIST=0
DRY_RUN=0

# ---------- output helpers ----------
if [[ -t 1 ]]; then
  GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
  GREEN=""; YELLOW=""; RED=""; RESET=""
fi
info() { printf '%s==>%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%swarn:%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
die()  { printf '%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

  (no options)             install the "general" profile only
  -p=a,b, --profiles=a,b   install these profiles (general is always included)
  --profiles=ALL           install every profile in profiles/ (not personal/)
  -r=a,b, --remove=a,b     disable these profiles
  --list-profiles          show available profiles
  --dry-run                print what would happen, change nothing
  -h, --help               show this help
EOF
}

# Run a command, or just print it when --dry-run is set.
run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# ---------- profile helpers ----------
check_name() {
  [[ "$1" =~ ^[A-Za-z0-9_-]+$ ]] || die "invalid profile name: $1"
}

# Print the path of a profile file (profiles/ first, then personal/).
profile_file() {
  local dir
  for dir in profiles personal; do
    if [[ -f "$SCRIPT_DIR/$dir/$1.zsh" ]]; then
      printf '%s\n' "$SCRIPT_DIR/$dir/$1.zsh"
      return 0
    fi
  done
  return 1
}

list_profiles() {
  local f name desc
  for f in "$SCRIPT_DIR"/profiles/*.zsh "$SCRIPT_DIR"/personal/*.zsh; do
    [[ -f "$f" ]] || continue
    name="$(basename "$f" .zsh)"
    desc="$(head -n 1 "$f" | sed -n 's/^# profile: [^ ]* - //p')"
    printf '%-14s %s\n' "$name" "$desc"
  done
}

install_profile() {
  local name="$1" src
  check_name "$name"
  src="$(profile_file "$name")" || die "unknown profile: $name (see --list-profiles)"
  run ln -sfn "$src" "$TARGET_DIR/$name.zsh"
  info "enabled: $name"
}

remove_profile() {
  local name="$1" link="$TARGET_DIR/$1.zsh"
  check_name "$name"
  [[ "$name" != "general" ]] || die "general is always installed; use ./uninstall.sh to remove everything"
  if [[ -L "$link" ]]; then
    run rm "$link"
    info "removed: $name"
  else
    warn "not enabled: $name"
  fi
}

# Append the loader block to ~/.zshrc once, after taking a backup.
install_loader() {
  if [[ -f "$ZSHRC" ]] && grep -qF "$MARK_START" "$ZSHRC"; then
    info "loader already present in $ZSHRC"
    return
  fi
  if [[ -f "$ZSHRC" ]]; then
    run cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d%H%M%S)"
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '[dry-run] append loader block to %s\n' "$ZSHRC"
  else
    { printf '\n'; cat "$SCRIPT_DIR/zshrc_loader.zsh"; } >> "$ZSHRC"
    info "added loader to $ZSHRC"
  fi
}

# ---------- parse arguments ----------
for arg in "$@"; do
  case "$arg" in
    --profiles=*|-p=*) PROFILES="${arg#*=}" ;;
    --remove=*|-r=*)   REMOVE="${arg#*=}" ;;
    --list-profiles)   LIST=1 ;;
    --dry-run)         DRY_RUN=1 ;;
    -h|--help)         usage; exit 0 ;;
    *)                 die "unknown option: $arg (try --help)" ;;
  esac
done

# ---------- main ----------
if [[ $LIST -eq 1 ]]; then
  list_profiles
  exit 0
fi

[[ "$(uname)" == "Darwin" ]] || warn "built for macOS; some aliases (e.g. awake) won't work here"

if [[ -n "$REMOVE" ]]; then
  for name in ${REMOVE//,/ }; do
    remove_profile "$name"
  done
  exit 0
fi

selected="general"
if [[ "$PROFILES" == "ALL" ]]; then
  for f in "$SCRIPT_DIR"/profiles/*.zsh; do
    selected="$selected $(basename "$f" .zsh)"
  done
else
  selected="$selected ${PROFILES//,/ }"
fi

run mkdir -p "$TARGET_DIR"
for name in $selected; do
  install_profile "$name"
done
install_loader

info "done. Reload your shell with: source ~/.zshrc"
