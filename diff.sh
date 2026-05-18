#!/bin/bash
# diff.sh
#
# Compares each skill installed in a target project against the agent-config source.
# Reports whether each skill is: current, behind (source is newer), or locally modified.
#
# Usage:
#   ~/GitHub/agent-config/diff.sh [TARGET_DIR]
#
#   TARGET_DIR defaults to the current working directory.
#
# Output:
#   current          — installed file is identical to source
#   behind           — source has changed since install (update available)
#   locally-modified — installed file differs from source (may have local edits)
#   source-missing   — installed file has no matching source (orphaned)
#
# Flags:
#   --behind-only    Only list skills that are behind or locally modified (hide current)
#   --json           Output as JSON array
#
# How it works:
#   Compares SHA-256 checksums of installed SKILL.md files against source SKILL.md files.
#   A file is "locally modified" if it differs from source. There is no install history,
#   so "behind" and "locally modified" look the same from checksums alone.
#   A file that differs is flagged as "modified" — the user decides if it needs updating.
#
# Note: .local.md overlays are never touched by update.sh and are not tracked here.
#   Only the base SKILL.md files are compared.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS="$SCRIPT_DIR/skills"
TARGET_DIR="${1:-$PWD}"
BEHIND_ONLY=false
JSON=false

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --behind-only)  BEHIND_ONLY=true ;;
    --json)         JSON=true ;;
    --*)            echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

# Strip positional target dir from arg processing
if [[ "${1:-}" != "--"* ]] && [[ -n "${1:-}" ]]; then
  TARGET_DIR="$1"
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

TARGET_SKILLS="$TARGET_DIR/skills"

if [ ! -d "$TARGET_SKILLS" ]; then
  echo "No skills/ directory found in $TARGET_DIR"
  echo "Run init.sh to set up agent-config in this project."
  exit 0
fi

# ── Compare skills ────────────────────────────────────────────────────────────

RESULTS=()

for installed_file in "$TARGET_SKILLS"/*/SKILL.md; do
  [ -f "$installed_file" ] || continue

  skill_dir=$(basename "$(dirname "$installed_file")")
  source_file="$SOURCE_SKILLS/$skill_dir/SKILL.md"

  if [ ! -f "$source_file" ]; then
    RESULTS+=("source-missing|$skill_dir")
    continue
  fi

  installed_sum=$(shasum -a 256 "$installed_file" | awk '{print $1}')
  source_sum=$(shasum -a 256 "$source_file" | awk '{print $1}')

  if [ "$installed_sum" = "$source_sum" ]; then
    RESULTS+=("current|$skill_dir")
  else
    RESULTS+=("modified|$skill_dir")
  fi
done

# Also check for source skills not installed in target
for source_file in "$SOURCE_SKILLS"/*/SKILL.md; do
  [ -f "$source_file" ] || continue
  skill_dir=$(basename "$(dirname "$source_file")")
  installed_file="$TARGET_SKILLS/$skill_dir/SKILL.md"
  if [ ! -f "$installed_file" ]; then
    RESULTS+=("not-installed|$skill_dir")
  fi
done

# Sort by status then name
IFS=$'\n' SORTED=($(printf '%s\n' "${RESULTS[@]}" | sort))
unset IFS

# ── Output ────────────────────────────────────────────────────────────────────

if $JSON; then
  echo "["
  first=true
  for entry in "${SORTED[@]}"; do
    status="${entry%%|*}"
    skill="${entry##*|}"
    $BEHIND_ONLY && [ "$status" = "current" ] && continue
    $BEHIND_ONLY && [ "$status" = "not-installed" ] && continue
    [ "$first" = false ] && echo ","
    printf '  {"skill": "%s", "status": "%s"}' "$skill" "$status"
    first=false
  done
  echo ""
  echo "]"
else
  if ! $BEHIND_ONLY; then
    printf "%-24s %s\n" "SKILL" "STATUS"
    printf "%-24s %s\n" "───────────────────────" "──────────────────"
  fi

  CURRENT=0
  MODIFIED=0
  MISSING=0
  NOT_INSTALLED=0

  for entry in "${SORTED[@]}"; do
    status="${entry%%|*}"
    skill="${entry##*|}"

    case "$status" in
      current)
        (( CURRENT++ )) || true
        $BEHIND_ONLY && continue
        printf "%-24s current\n" "$skill"
        ;;
      modified)
        (( MODIFIED++ )) || true
        printf "%-24s MODIFIED (differs from source)\n" "$skill"
        ;;
      source-missing)
        (( MISSING++ )) || true
        $BEHIND_ONLY && continue
        printf "%-24s orphaned (no source)\n" "$skill"
        ;;
      not-installed)
        (( NOT_INSTALLED++ )) || true
        $BEHIND_ONLY && continue
        printf "%-24s not installed\n" "$skill"
        ;;
    esac
  done

  echo ""
  echo "Summary: $CURRENT current, $MODIFIED modified, $MISSING orphaned, $NOT_INSTALLED not installed"

  if [ "$MODIFIED" -gt 0 ]; then
    echo ""
    echo "To update modified skills:"
    echo "  ~/GitHub/agent-config/update.sh $TARGET_DIR --force"
    echo ""
    echo "WARNING: --force overwrites local edits. Back up your changes first."
    echo "Use .local.md overlays for project-specific additions (never touched by update.sh)."
  fi
fi
