#!/bin/bash
# agent-config/search.sh
#
# Search skills by name, category, tags, or description.
#
# Usage:
#   ./search.sh <query>
#   ./search.sh accessibility
#   ./search.sh "code quality"

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"

if [ -z "$1" ]; then
  echo "Usage: ./search.sh <query>"
  exit 1
fi

QUERY=$(echo "$1" | tr '[:upper:]' '[:lower:]')
MATCHES=0

printf "%-22s %-14s %s\n" "SKILL" "CATEGORY" "DESCRIPTION"
printf "%-22s %-14s %s\n" "─────────────────────" "─────────────" "────────────────────────────────────────────────────"

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"
  [ ! -f "$skill_file" ] && continue

  category=$(awk '/^---/{f=!f; next} f && /^category:/{sub(/^category:[[:space:]]*/, ""); print; exit}' "$skill_file")
  tags=$(awk '/^---/{f=!f; next} f && /^tags:/{sub(/^tags:[[:space:]]*/, ""); print; exit}' "$skill_file")
  desc=$(awk '/^---/{f=!f; next} f && /^description:/{found=1; next} found && /^[^ ]/{exit} found{gsub(/^[[:space:]]+/, ""); printf "%s ", $0}' "$skill_file")

  haystack=$(echo "$skill_name $category $tags $desc" | tr '[:upper:]' '[:lower:]')

  if echo "$haystack" | grep -q "$QUERY"; then
    short_desc=$(echo "$desc" | cut -c1-60)
    printf "%-22s %-14s %s\n" "$skill_name" "${category:-—}" "$short_desc"
    MATCHES=$((MATCHES + 1))
  fi
done

echo ""
[ $MATCHES -eq 0 ] && echo "No skills matched \"$1\"." || echo "$MATCHES skill(s) matched."
