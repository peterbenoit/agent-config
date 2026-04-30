#!/bin/bash
# agent-config/validate.sh
#
# Validates the agent-config toolkit for common drift and structural errors.
#
# Usage:
#   ./validate.sh
#
# Checks:
#   1. Every active SKILL.md has YAML frontmatter with name and description fields
#   2. The frontmatter name matches the skill folder name
#   3. Every active skill appears in skills/README.md
#   4. Every active skill appears in the root README.md skills table
#   5. Hook scripts are executable
#   6. init.sh heredoc Architecture/WhatNotToDo placeholders match templates/agents-default.md

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"
SKILLS_README="$AGENT_CONFIG_DIR/skills/README.md"
ROOT_README="$AGENT_CONFIG_DIR/README.md"
HOOKS_DIR="$AGENT_CONFIG_DIR/hooks"
INIT_SH="$AGENT_CONFIG_DIR/init.sh"

errors=0
warnings=0

fail()    { echo "  FAIL  $1"; errors=$((errors + 1)); }
warn()    { echo "  WARN  $1"; warnings=$((warnings + 1)); }
ok()      { echo "  ok    $1"; }
section() { echo ""; echo "── $1"; }

echo ""
echo "agent-config validate"
echo "  dir: $AGENT_CONFIG_DIR"

# ── 1. SKILL.md frontmatter ───────────────────────────────────────────────────

section "Skill frontmatter"

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  # Skip deferred folders (no SKILL.md)
  [ ! -f "$skill_file" ] && continue

  # Check frontmatter delimiters exist
  if ! grep -q "^---" "$skill_file"; then
    fail "$skill_name: missing YAML frontmatter (no --- delimiters)"
    continue
  fi

  # Extract name field
  fm_name=$(awk '/^---/{f=!f; next} f && /^name:/{print $2; exit}' "$skill_file")
  if [ -z "$fm_name" ]; then
    fail "$skill_name: frontmatter missing 'name' field"
  elif [ "$fm_name" != "$skill_name" ]; then
    fail "$skill_name: frontmatter name '$fm_name' does not match folder name '$skill_name'"
  else
    ok "$skill_name: name matches"
  fi

  # Check description field exists
  fm_desc=$(awk '/^---/{f=!f; next} f && /^description:/{found=1} found{print; if (/^[a-z]/ && !/^description/) exit}' "$skill_file" | grep -c ".")
  if [ "$fm_desc" -eq 0 ]; then
    fail "$skill_name: frontmatter missing 'description' field"
  fi
done

# ── 2. Skills listed in skills/README.md ─────────────────────────────────────

section "skills/README.md coverage"

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  [ ! -f "$skill_dir/SKILL.md" ] && continue  # skip deferred

  if grep -q "\`$skill_name\`" "$SKILLS_README"; then
    ok "$skill_name: listed in skills/README.md"
  else
    fail "$skill_name: NOT listed in skills/README.md"
  fi
done

# ── 3. Skills listed in root README.md ───────────────────────────────────────

section "root README.md coverage"

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  [ ! -f "$skill_dir/SKILL.md" ] && continue  # skip deferred

  if grep -q "\`$skill_name\`" "$ROOT_README"; then
    ok "$skill_name: listed in root README.md"
  else
    fail "$skill_name: NOT listed in root README.md"
  fi
done

# ── 4. Hook scripts are executable ───────────────────────────────────────────

section "Hook executability"

for hook in "$HOOKS_DIR"/*.sh; do
  hook_name=$(basename "$hook")
  if [ -x "$hook" ]; then
    ok "$hook_name: executable"
  else
    fail "$hook_name: not executable (run: chmod +x hooks/$hook_name)"
  fi
done

# ── 5. init.sh heredoc vs templates/agents-default.md ────────────────────────

section "init.sh heredoc vs template"

template_file="$AGENT_CONFIG_DIR/templates/agents-default.md"
if [ ! -f "$template_file" ]; then
  warn "templates/agents-default.md not found — skipping heredoc check"
else
  # Extract heredoc content from init.sh (between << 'EOF' and ^EOF$)
  start_line=$(grep -n "<< 'EOF'" "$INIT_SH" | head -1 | cut -d: -f1)
  if [ -z "$start_line" ]; then
    fail "Could not locate heredoc in init.sh"
  else
    heredoc=$(awk "NR==$start_line,/^EOF\$/{if(NR>$start_line && /^EOF\$/) exit; if(NR>$start_line) print}" "$INIT_SH")

    diff_output=$(diff <(echo "$heredoc") "$template_file")
    if [ -z "$diff_output" ]; then
      ok "init.sh heredoc matches templates/agents-default.md exactly"
    else
      fail "init.sh heredoc differs from templates/agents-default.md"
      echo "$diff_output" | head -30 | sed 's/^/    /'
    fi
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "────────────────────────────────"
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
  echo "All checks passed."
elif [ $errors -eq 0 ]; then
  echo "Passed with $warnings warning(s). No failures."
else
  echo "$errors failure(s), $warnings warning(s)."
  exit 1
fi
echo ""
