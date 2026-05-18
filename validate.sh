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

  # Check category field exists and is an allowed value
  fm_cat=$(awk '/^---/{f=!f; next} f && /^category:/{sub(/^category:[[:space:]]*/, ""); print; exit}' "$skill_file")
  if [ -z "$fm_cat" ]; then
    fail "$skill_name: frontmatter missing 'category' field"
  else
    case "$fm_cat" in
      Accessibility|"Code Quality"|Content|Security|Workflow|Meta)
        ok "$skill_name: category '$fm_cat' is valid" ;;
      *)
        fail "$skill_name: category '$fm_cat' is not an allowed value (Accessibility, Code Quality, Content, Security, Workflow, Meta)" ;;
    esac
  fi

  # Check tags field exists and is non-empty
  fm_tags=$(awk '/^---/{f=!f; next} f && /^tags:/{sub(/^tags:[[:space:]]*/, ""); print; exit}' "$skill_file")
  if [ -z "$fm_tags" ] || [ "$fm_tags" = "[]" ]; then
    fail "$skill_name: frontmatter missing or empty 'tags' field"
  fi

  # Check updated field exists
  fm_updated=$(awk '/^---/{f=!f; next} f && /^updated:/{sub(/^updated:[[:space:]]*/, ""); print; exit}' "$skill_file")
  if [ -z "$fm_updated" ]; then
    warn "$skill_name: frontmatter missing 'updated' field (add 'updated: YYYY-MM-DD')"
  fi

  # Check description has at least 4 trigger phrases (quoted or backtick phrases)
  desc_block=$(awk '/^---/{f=!f; next} f && /^description:/{p=1} p{print} p && /^[a-z]/ && !/^description/{exit}' "$skill_file")
  trigger_count=$(echo "$desc_block" | grep -oE '"[^"]{3,}"|`[^`]{3,}`' | wc -l | tr -d ' ')
  if [ "$trigger_count" -lt 4 ]; then
    warn "$skill_name: description has $trigger_count quoted/backtick trigger phrases (recommend at least 4)"
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

# ── 6. instructions/*.instructions.md frontmatter ────────────────────────────

section "Instruction frontmatter"

INSTRUCTIONS_DIR="$AGENT_CONFIG_DIR/instructions"
INSTRUCTIONS_README="$AGENT_CONFIG_DIR/instructions/README.md"

for instr_file in "$INSTRUCTIONS_DIR"/*.instructions.md; do
  [ -f "$instr_file" ] || continue
  instr_name=$(basename "$instr_file")

  if ! grep -q "^---" "$instr_file"; then
    fail "$instr_name: missing YAML frontmatter"
    continue
  fi

  for field in name description applyTo; do
    if awk '/^---/{f=!f; next} f' "$instr_file" | grep -q "^$field:"; then
      ok "$instr_name: has '$field'"
    else
      fail "$instr_name: frontmatter missing '$field'"
    fi
  done

  # Coverage check against instructions/README.md
  base="${instr_name%.instructions.md}"
  if grep -q "$base" "$INSTRUCTIONS_README"; then
    ok "$instr_name: listed in instructions/README.md"
  else
    fail "$instr_name: NOT listed in instructions/README.md"
  fi
done

# ── 7. prompts/*.prompt.md frontmatter ───────────────────────────────────────

section "Prompt frontmatter"

PROMPTS_DIR="$AGENT_CONFIG_DIR/prompts"
PROMPTS_README="$AGENT_CONFIG_DIR/prompts/README.md"

for prompt_file in "$PROMPTS_DIR"/*.prompt.md; do
  [ -f "$prompt_file" ] || continue
  prompt_name=$(basename "$prompt_file")

  if ! grep -q "^---" "$prompt_file"; then
    fail "$prompt_name: missing YAML frontmatter"
    continue
  fi

  for field in name description; do
    if awk '/^---/{f=!f; next} f' "$prompt_file" | grep -q "^$field:"; then
      ok "$prompt_name: has '$field'"
    else
      fail "$prompt_name: frontmatter missing '$field'"
    fi
  done

  # Must have at least one of: agent, mode
  if awk '/^---/{f=!f; next} f' "$prompt_file" | grep -qE "^(agent|mode):"; then
    ok "$prompt_name: has 'agent' or 'mode'"
  else
    fail "$prompt_name: frontmatter missing 'agent' or 'mode' field"
  fi

  # Coverage check against prompts/README.md
  base="${prompt_name%.prompt.md}"
  if grep -q "$base" "$PROMPTS_README"; then
    ok "$prompt_name: listed in prompts/README.md"
  else
    fail "$prompt_name: NOT listed in prompts/README.md"
  fi
done

# ── 8. context/*.md listed in context/README.md ──────────────────────────────

section "context/README.md coverage"

CONTEXT_DIR="$AGENT_CONFIG_DIR/context"
CONTEXT_README="$CONTEXT_DIR/README.md"

for ctx_file in "$CONTEXT_DIR"/*.md; do
  ctx_name=$(basename "$ctx_file")
  [ "$ctx_name" = "README.md" ] && continue

  base="${ctx_name%.md}"
  if grep -q "$base" "$CONTEXT_README"; then
    ok "$ctx_name: listed in context/README.md"
  else
    fail "$ctx_name: NOT listed in context/README.md"
  fi
done

# ── 8b. context/*.md content structure ───────────────────────────────────────

section "context file structure"

for ctx_file in "$CONTEXT_DIR"/*.md; do
  ctx_name=$(basename "$ctx_file")
  [ "$ctx_name" = "README.md" ] && continue

  if [ ! -s "$ctx_file" ]; then
    fail "$ctx_name: file is empty"
  elif ! grep -q "^#" "$ctx_file"; then
    fail "$ctx_name: no markdown heading found"
  else
    ok "$ctx_name: has content and heading"
  fi
done

# ── 9. templates/agents-*.md listed in templates/README.md ───────────────────

section "templates/README.md coverage"

TEMPLATES_DIR="$AGENT_CONFIG_DIR/templates"
TEMPLATES_README="$TEMPLATES_DIR/README.md"

for tmpl_file in "$TEMPLATES_DIR"/agents-*.md; do
  tmpl_name=$(basename "$tmpl_file")
  if grep -q "$tmpl_name" "$TEMPLATES_README"; then
    ok "$tmpl_name: listed in templates/README.md"
  else
    fail "$tmpl_name: NOT listed in templates/README.md"
  fi
done

# ── 9b. templates: required HTML comment placeholders ────────────────────────

section "template placeholder check"

for tmpl_file in "$TEMPLATES_DIR"/agents-*.md; do
  tmpl_name=$(basename "$tmpl_file")
  if grep -q "<!--" "$tmpl_file"; then
    ok "$tmpl_name: has HTML comment placeholders"
  else
    fail "$tmpl_name: no <!-- --> placeholders found (may have been filled in and committed)"
  fi
done

# ── 10. Global symlink health ─────────────────────────────────────────────────

section "Global symlink health"

SKILLS_SRC="$AGENT_CONFIG_DIR/skills"
for target in ~/.agents/skills ~/.claude/skills ~/.codex/skills; do
  expanded="${target/#\~/$HOME}"
  if [ ! -L "$expanded" ]; then
    warn "$target: missing symlink (fix: ln -s $SKILLS_SRC $expanded)"
  else
    ok "$target: symlink present"
  fi
done

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
