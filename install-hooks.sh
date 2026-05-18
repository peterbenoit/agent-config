#!/bin/bash
# install-hooks.sh
#
# Copies agent-config hooks into a target project and wires them into
# .claude/settings.json. Companion to init.sh (which copies skills).
#
# Usage:
#   ~/GitHub/agent-config/install-hooks.sh [TARGET_DIR]
#
#   TARGET_DIR defaults to the current working directory.
#
# What it does:
#   1. Creates TARGET/.claude/hooks/ if it doesn't exist
#   2. Copies selected hooks from agent-config/hooks/ (skips test-*.sh)
#   3. Makes each hook executable
#   4. Creates or updates TARGET/.claude/settings.json with hook config
#
# Flags:
#   --all         Install all non-test hooks (default: interactive selection)
#   --list        List available hooks and exit
#   --dry-run     Show what would happen without doing anything
#
# Settings.json merge strategy:
#   - If .claude/settings.json does not exist, it is created.
#   - If it exists and already has hook config, the script reports the conflict
#     and does not overwrite — merge manually.
#
# Requires: jq (for settings.json merge detection)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_SOURCE="$SCRIPT_DIR/hooks"
TARGET_DIR="${1:-$PWD}"
DRY_RUN=false
INSTALL_ALL=false
LIST_ONLY=false

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --all)       INSTALL_ALL=true ;;
    --list)      LIST_ONLY=true ;;
    --*)         echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

# Strip the target dir from args if it was provided positionally
if [[ "${1:-}" != "--"* ]] && [[ -n "${1:-}" ]]; then
  TARGET_DIR="$1"
fi

# ── List available hooks ──────────────────────────────────────────────────────

AVAILABLE_HOOKS=()
while IFS= read -r -d '' hook; do
  name=$(basename "$hook")
  if [[ "$name" != test-* ]]; then
    AVAILABLE_HOOKS+=("$name")
  fi
done < <(find "$HOOKS_SOURCE" -maxdepth 1 -name "*.sh" -print0 | sort -z)

if $LIST_ONLY; then
  echo "Available hooks:"
  for hook in "${AVAILABLE_HOOKS[@]}"; do
    echo "  $hook"
  done
  exit 0
fi

# ── Resolve target ────────────────────────────────────────────────────────────

if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

HOOKS_DEST="$TARGET_DIR/.claude/hooks"
SETTINGS_FILE="$TARGET_DIR/.claude/settings.json"

echo "Target: $TARGET_DIR"
echo ""

# ── Select hooks to install ───────────────────────────────────────────────────

if $INSTALL_ALL; then
  SELECTED_HOOKS=("${AVAILABLE_HOOKS[@]}")
else
  # Default selection: the three most broadly useful hooks
  SELECTED_HOOKS=(
    "block-dangerous-git.sh"
    "block-file-writes.sh"
    "log-tool-use.sh"
  )
  echo "Default hooks to install (use --all for all hooks):"
  for hook in "${SELECTED_HOOKS[@]}"; do
    echo "  $hook"
  done
  echo ""
fi

# ── Copy hooks ────────────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  mkdir -p "$HOOKS_DEST"
fi

for hook in "${SELECTED_HOOKS[@]}"; do
  SRC="$HOOKS_SOURCE/$hook"
  DEST="$HOOKS_DEST/$hook"
  if [ ! -f "$SRC" ]; then
    echo "  SKIP  $hook (not found in source)"
    continue
  fi
  if $DRY_RUN; then
    echo "  [dry] copy  $hook → .claude/hooks/$hook"
  else
    cp "$SRC" "$DEST"
    chmod +x "$DEST"
    echo "  ok    $hook"
  fi
done

echo ""

# ── settings.json ─────────────────────────────────────────────────────────────

# Build the settings.json content for the selected hooks
# PreToolUse hooks (block-dangerous-git, block-file-writes, check-test-before-commit)
# PostToolUse hooks (log-tool-use)

PRE_HOOKS=()
POST_HOOKS=()

for hook in "${SELECTED_HOOKS[@]}"; do
  case "$hook" in
    log-tool-use.sh)
      POST_HOOKS+=("$hook")
      ;;
    *)
      PRE_HOOKS+=("$hook")
      ;;
  esac
done

if [ -f "$SETTINGS_FILE" ] && command -v jq &>/dev/null; then
  EXISTING_HOOKS=$(jq '.hooks // {}' "$SETTINGS_FILE" 2>/dev/null)
  if [ "$EXISTING_HOOKS" != "{}" ]; then
    echo "WARNING: $SETTINGS_FILE already has hook configuration."
    echo "Merge manually to avoid overwriting existing hooks."
    echo ""
    echo "Add these entries to PreToolUse:"
    for hook in "${PRE_HOOKS[@]}"; do
      echo "  { \"type\": \"command\", \"command\": \"\\\"\$CLAUDE_PROJECT_DIR\\\"/.claude/hooks/$hook\" }"
    done
    if [ ${#POST_HOOKS[@]} -gt 0 ]; then
      echo ""
      echo "Add these entries to PostToolUse:"
      for hook in "${POST_HOOKS[@]}"; do
        echo "  { \"type\": \"command\", \"command\": \"\\\"\$CLAUDE_PROJECT_DIR\\\"/.claude/hooks/$hook\" }"
      done
    fi
    exit 0
  fi
fi

# Generate settings.json
PRE_ENTRIES=""
for hook in "${PRE_HOOKS[@]}"; do
  [ -n "$PRE_ENTRIES" ] && PRE_ENTRIES="$PRE_ENTRIES,"$'\n'
  PRE_ENTRIES="${PRE_ENTRIES}        { \"type\": \"command\", \"command\": \"\\\"\$CLAUDE_PROJECT_DIR\\\"/.claude/hooks/$hook\" }"
done

POST_ENTRIES=""
for hook in "${POST_HOOKS[@]}"; do
  [ -n "$POST_ENTRIES" ] && POST_ENTRIES="$POST_ENTRIES,"$'\n'
  POST_ENTRIES="${POST_ENTRIES}        { \"type\": \"command\", \"command\": \"\\\"\$CLAUDE_PROJECT_DIR\\\"/.claude/hooks/$hook\" }"
done

SETTINGS_CONTENT='{
  "hooks": {'

if [ -n "$PRE_ENTRIES" ]; then
  SETTINGS_CONTENT="$SETTINGS_CONTENT
    \"PreToolUse\": [
      {
        \"hooks\": [
$PRE_ENTRIES
        ]
      }
    ]"
fi

if [ -n "$PRE_ENTRIES" ] && [ -n "$POST_ENTRIES" ]; then
  SETTINGS_CONTENT="$SETTINGS_CONTENT,"
fi

if [ -n "$POST_ENTRIES" ]; then
  SETTINGS_CONTENT="$SETTINGS_CONTENT
    \"PostToolUse\": [
      {
        \"hooks\": [
$POST_ENTRIES
        ]
      }
    ]"
fi

SETTINGS_CONTENT="$SETTINGS_CONTENT
  }
}"

if $DRY_RUN; then
  echo "[dry] would write .claude/settings.json:"
  echo "$SETTINGS_CONTENT"
else
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  printf '%s\n' "$SETTINGS_CONTENT" > "$SETTINGS_FILE"
  echo "  ok    .claude/settings.json"
fi

echo ""
echo "Done. Hooks installed in .claude/hooks/"
echo "Review .claude/settings.json before your next agent session."
