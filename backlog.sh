#!/usr/bin/env bash
# backlog.sh — show open items in IMPROVEMENTS.md grouped by section
# Human wants this to be less specific to IMPROVMENTS.md since it might be called something else in other repos, TODO, BACKLOG, etc. Maybe look for "## Backlog" section and parse from there?
# Usage: ./backlog.sh [--all]
#   --all   also show completed items (for progress overview)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$SCRIPT_DIR/IMPROVEMENTS.md"
SHOW_ALL=false

[ "${1:-}" = "--all" ] && SHOW_ALL=true

if [ ! -f "$FILE" ]; then
  echo "IMPROVEMENTS.md not found at $FILE" >&2
  exit 1
fi

open_count=0
done_count=0
current_section=""
printed_section=false

while IFS= read -r line; do
  # Track section headers (## level only, skip deeper headers and non-backlog sections)
  if echo "$line" | grep -qE "^## "; then
    section=$(echo "$line" | sed 's/^## //')
    # Stop at non-item sections
    case "$section" in
      "Summary by Effort"|"Gap Analysis"*|"Global Agent Distribution"*|"Human Notes")
        break ;;
    esac
    current_section="$section"
    printed_section=false
    continue
  fi

  # Open items
  if echo "$line" | grep -qE "^\- \[ \]"; then
    open_count=$((open_count + 1))
    if [ -n "$current_section" ] && [ "$printed_section" = false ]; then
      printf '\n\033[1;33m%s\033[0m\n' "$current_section"
      printed_section=true
    fi
    # Print item number + title (strip markdown bold)
    label=$(echo "$line" | sed 's/^- \[ \] \*\*//; s/\*\*.*//')
    printf '  \033[31m○\033[0m %s\n' "$label"
    continue
  fi

  # Completed items (only shown with --all)
  if $SHOW_ALL && echo "$line" | grep -qE "^\- \[x\]"; then
    done_count=$((done_count + 1))
    if [ -n "$current_section" ] && [ "$printed_section" = false ]; then
      printf '\n\033[1;33m%s\033[0m\n' "$current_section"
      printed_section=true
    fi
    label=$(echo "$line" | sed 's/^- \[x\] \*\*//; s/\*\*.*//')
    printf '  \033[32m✓\033[0m %s\n' "$label"
    continue
  fi

  # Count completed items even if not displaying
  if ! $SHOW_ALL && echo "$line" | grep -qE "^\- \[x\]"; then
    done_count=$((done_count + 1))
  fi
done < "$FILE"

printf '\n'
if [ "$open_count" -eq 0 ]; then
  printf '\033[32mAll items complete.\033[0m %d done.\n' "$done_count"
else
  printf '\033[1m%d open\033[0m, %d done' "$open_count" "$done_count"
  total=$((open_count + done_count))
  pct=$(( done_count * 100 / total ))
  printf ' (%d%% complete)\n' "$pct"
fi
