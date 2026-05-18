#!/usr/bin/env bash
# build.sh — generate registry.json from all skill frontmatter
# Usage: ./build.sh [--output path/to/registry.json]
# Output defaults to registry.json in the repo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
OUTPUT="${1:-}"

if [ "$OUTPUT" = "--output" ]; then
  OUTPUT="${2:-$SCRIPT_DIR/registry.json}"
elif [ -z "$OUTPUT" ]; then
  OUTPUT="$SCRIPT_DIR/registry.json"
fi

# Require jq
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required (brew install jq)" >&2
  exit 1
fi

skills_json="[]"

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_file="$skill_dir/SKILL.md"
  [ -f "$skill_file" ] || continue

  skill_name=$(basename "$skill_dir")

  # Extract frontmatter fields
  fm_name=$(awk '/^---/{f=!f; next} f && /^name:/{sub(/^name:[[:space:]]*/, ""); print; exit}' "$skill_file")
  fm_category=$(awk '/^---/{f=!f; next} f && /^category:/{sub(/^category:[[:space:]]*/, ""); print; exit}' "$skill_file")

  # Tags: strip leading "tags:" and surrounding brackets
  fm_tags_raw=$(awk '/^---/{f=!f; next} f && /^tags:/{sub(/^tags:[[:space:]]*/, ""); print; exit}' "$skill_file" | sed 's/^\[//; s/\]$//')
  
  # Use jq to handle the CSV-like list of tags, whether quoted or not
  fm_tags_json=$(jq -Rn --arg tags "$fm_tags_raw" '$tags | split(",") | map(gsub("^[[:space:]]+|[[:space:]]+$"; "")) | map(gsub("^\"|\"$"; "")) | map(select(. != ""))')

  # Description: block scalar value (lines after "description: >", up to next key)
  fm_desc=$(awk '
    /^---/{f=!f; next}
    f && /^description:[[:space:]]*>/{in_desc=1; next}
    f && in_desc && /^[a-zA-Z]/{exit}
    f && in_desc{gsub(/^[[:space:]]+/,""); printf "%s ", $0}
  ' "$skill_file" | sed 's/[[:space:]]*$//')

  # Fallback: plain scalar description
  if [ -z "$fm_desc" ]; then
    fm_desc=$(awk '/^---/{f=!f; next} f && /^description:/{sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_file")
  fi

  # Build JSON object for this skill
  skill_obj=$(jq -n \
    --arg name "$fm_name" \
    --arg dir "$skill_name" \
    --arg category "$fm_category" \
    --argjson tags "$fm_tags_json" \
    --arg description "$fm_desc" \
    '{name: $name, dir: $dir, category: $category, tags: $tags, description: $description}')

  skills_json=$(echo "$skills_json" | jq --argjson s "$skill_obj" '. + [$s]')
done

# Sort by name
skills_json=$(echo "$skills_json" | jq 'sort_by(.name)')

# Wrap in top-level object with metadata
version=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "0.0.0")
generated=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

registry=$(jq -n \
  --arg version "$version" \
  --arg generated "$generated" \
  --argjson skills "$skills_json" \
  '{version: $version, generated: $generated, skills: $skills}')

echo "$registry" > "$OUTPUT"
echo "registry.json written to $OUTPUT ($(echo "$skills_json" | jq 'length') skills)"
