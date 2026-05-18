#!/bin/bash
# agent-config/new-skill.sh
#
# Scaffold a new skill directory and SKILL.md stub.
#
# Usage:
#   ./new-skill.sh <skill-name>
#   ./new-skill.sh database
#   ./new-skill.sh ci-cd

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"

if [ -z "$1" ]; then
  echo "Usage: ./new-skill.sh <skill-name>"
  exit 1
fi

SKILL_NAME="$1"
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"
SKILL_FILE="$SKILL_DIR/SKILL.md"

if [ -d "$SKILL_DIR" ]; then
  echo "Error: skills/$SKILL_NAME already exists."
  exit 1
fi

mkdir -p "$SKILL_DIR"

cat > "$SKILL_FILE" << EOF
---
name: $SKILL_NAME
category: Workflow
tags: [$SKILL_NAME]
description: >
  Act as the $SKILL_NAME specialist. Use when... Trigger on phrases like
  "$SKILL_NAME", "help with $SKILL_NAME", or any task involving $SKILL_NAME.
---

# $(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')

<!-- Replace this file with the skill content. See existing skills for examples. -->

## Role

## Methodology

## Project Context

Check the project's AGENTS.md or a local \`skills/$SKILL_NAME.local.md\` overlay for
project-specific configuration.
EOF

echo "Created skills/$SKILL_NAME/SKILL.md"
echo ""
echo "Next steps:"
echo "  1. Edit the frontmatter: category, tags, description"
echo "  2. Fill in Role, Methodology, and any checklists"
echo "  3. Add to skills/README.md and root README.md"
echo "  4. Run ./validate.sh to confirm it passes"
