#!/bin/bash
# agent-config/list.sh
#
# List all active skills with their category and description.
#
# Usage:
#   ./list.sh
#   ./list.sh --json

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"

JSON=false
[ "$1" = "--json" ] && JSON=true

if [ "$JSON" = true ]; then
  echo "["
  first=true
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    [ ! -f "$skill_file" ] && continue

    category=$(awk '/^---/{f=!f; next} f && /^category:/{sub(/^category:[[:space:]]*/, ""); print; exit}' "$skill_file")
    tags=$(awk '/^---/{f=!f; next} f && /^tags:/{sub(/^tags:[[:space:]]*/, ""); print; exit}' "$skill_file")
    desc=$(awk '/^---/{f=!f; next} f && /^description:/{found=1; next} found && /^[^ ]/{exit} found{gsub(/^[[:space:]]+/, ""); printf "%s ", $0}' "$skill_file" | sed 's/[[:space:]]*$//')

    [ "$first" = false ] && echo ","
    printf '  {"name": "%s", "category": "%s", "tags": %s, "description": "%s"}' \
      "$skill_name" "$category" "$tags" "$(echo "$desc" | head -c 120 | sed 's/"/\\"/g')"
    first=false
  done
  echo ""
  echo "]"
else
  printf "%-22s %-14s %s\n" "SKILL" "CATEGORY" "DESCRIPTION"
  printf "%-22s %-14s %s\n" "─────────────────────" "─────────────" "────────────────────────────────────────────────────"
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    [ ! -f "$skill_file" ] && continue

    category=$(awk '/^---/{f=!f; next} f && /^category:/{sub(/^category:[[:space:]]*/, ""); print; exit}' "$skill_file")
    desc=$(awk '/^---/{f=!f; next} f && /^description:/{found=1; next} found && /^[^ ]/{exit} found{gsub(/^[[:space:]]+/, ""); printf "%s ", $0}' "$skill_file" | cut -c1-60)

    printf "%-22s %-14s %s\n" "$skill_name" "${category:-—}" "$desc"
  done
fi
