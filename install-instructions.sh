#!/bin/bash
# install-instructions.sh
#
# Copies agent-config instruction files into a target project's
# .github/instructions/ directory (the standard VS Code Copilot location).
#
# Usage:
#   ~/GitHub/agent-config/install-instructions.sh [TARGET_DIR]
#
#   TARGET_DIR defaults to the current working directory.
#
# What it does:
#   1. Creates TARGET/.github/instructions/ if it doesn't exist
#   2. Copies selected .instructions.md files from agent-config/instructions/
#   3. Does not overwrite files that already exist (use --force to overwrite)
#
# Flags:
#   --all         Install all available instructions (default: interactive selection)
#   --list        List available instruction files and exit
#   --force       Overwrite existing instruction files in the target project
#   --dry-run     Show what would happen without doing anything
#
# Note: Instructions fire automatically in VS Code Copilot when the active file
# matches their `applyTo` glob. Review the frontmatter of each file to understand
# what triggers it before installing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTRUCTIONS_SOURCE="$SCRIPT_DIR/instructions"
TARGET_DIR="${1:-$PWD}"
DRY_RUN=false
INSTALL_ALL=false
LIST_ONLY=false
FORCE=false

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true ;;
    --all)      INSTALL_ALL=true ;;
    --list)     LIST_ONLY=true ;;
    --force)    FORCE=true ;;
    --*)        echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

# Strip the target dir from positional arg if provided
if [[ "${1:-}" != "--"* ]] && [[ -n "${1:-}" ]]; then
  TARGET_DIR="$1"
fi

# ── List available instructions ───────────────────────────────────────────────

AVAILABLE=()
while IFS= read -r -d '' f; do
  AVAILABLE+=("$(basename "$f")")
done < <(find "$INSTRUCTIONS_SOURCE" -maxdepth 1 -name "*.instructions.md" -print0 | sort -z)

if $LIST_ONLY; then
  echo "Available instructions:"
  for f in "${AVAILABLE[@]}"; do
    echo "  $f"
  done
  exit 0
fi

# ── Resolve target ────────────────────────────────────────────────────────────

if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

DEST_DIR="$TARGET_DIR/.github/instructions"

echo "Target: $TARGET_DIR"
echo ""

# ── Select instructions to install ───────────────────────────────────────────

if $INSTALL_ALL; then
  SELECTED=("${AVAILABLE[@]}")
else
  # Default selection: all three (they're narrow enough to be safe anywhere)
  SELECTED=("${AVAILABLE[@]}")
  echo "Instructions to install:"
  for f in "${SELECTED[@]}"; do
    echo "  $f"
  done
  echo ""
fi

# ── Copy instructions ─────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  mkdir -p "$DEST_DIR"
fi

COPIED=0
SKIPPED=0

for f in "${SELECTED[@]}"; do
  SRC="$INSTRUCTIONS_SOURCE/$f"
  DEST="$DEST_DIR/$f"

  if [ ! -f "$SRC" ]; then
    echo "  SKIP  $f (not found in source)"
    (( SKIPPED++ )) || true
    continue
  fi

  if [ -f "$DEST" ] && ! $FORCE; then
    echo "  SKIP  $f (already exists — use --force to overwrite)"
    (( SKIPPED++ )) || true
    continue
  fi

  if $DRY_RUN; then
    echo "  [dry] copy  $f → .github/instructions/$f"
  else
    cp "$SRC" "$DEST"
    echo "  OK    $f → .github/instructions/$f"
    (( COPIED++ )) || true
  fi
done

echo ""

if $DRY_RUN; then
  echo "Dry run complete. No files were written."
else
  echo "Done. $COPIED installed, $SKIPPED skipped."
  echo ""
  echo "Instructions live in: $DEST_DIR"
  echo "They fire automatically in VS Code Copilot when the active file matches"
  echo "their 'applyTo' pattern. No further configuration needed."
fi
