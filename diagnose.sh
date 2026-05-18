#!/usr/bin/env bash
# diagnose.sh — full agent-config system health check
#
# Reports the state of your agent tooling at a glance:
#   - validate.sh pass/fail
#   - Global symlink status
#   - Skill count and registry freshness
#   - Hook install status in the current project
#   - Installed prompts in VS Code user prompts folder
#   - VERSION information
#
# Usage:
#   ./diagnose.sh                  # full report
#   ./diagnose.sh --brief          # summary only (pass/fail counts)

set -euo pipefail

BRIEF=false
[[ "${1:-}" == "--brief" ]] && BRIEF=true

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"
HOOKS_DIR="$AGENT_CONFIG_DIR/hooks"
PROMPTS_DIR="$AGENT_CONFIG_DIR/prompts"
REGISTRY="$AGENT_CONFIG_DIR/registry.json"
VERSION_FILE="$AGENT_CONFIG_DIR/VERSION"
VSCODE_PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"

pass=0
warn=0
fail=0

green="\033[0;32m"
yellow="\033[0;33m"
red="\033[0;31m"
bold="\033[1m"
reset="\033[0m"

ok()   { echo -e "  ${green}ok${reset}    $1"; ((pass++)) || true; }
warn() { echo -e "  ${yellow}warn${reset}  $1"; ((warn++)) || true; }
fail() { echo -e "  ${red}fail${reset}  $1"; ((fail++)) || true; }
section() { echo -e "\n${bold}── $1 ──${reset}"; }

# ── 1. Version ────────────────────────────────────────────────────────────────

section "Version"

if [ -f "$VERSION_FILE" ]; then
  ver=$(cat "$VERSION_FILE")
  ok "agent-config version: $ver"
else
  warn "VERSION file not found"
fi

# ── 2. validate.sh ────────────────────────────────────────────────────────────

section "Toolkit integrity (validate.sh)"

if bash "$AGENT_CONFIG_DIR/validate.sh" &>/dev/null; then
  ok "validate.sh passes all checks"
else
  fail "validate.sh has failures — run ./validate.sh for details"
fi

# ── 3. Skill count and registry ───────────────────────────────────────────────

section "Skills"

skill_count=0
for skill_dir in "$SKILLS_DIR"/*/; do
  [ -f "$skill_dir/SKILL.md" ] && ((skill_count++)) || true
done
ok "$skill_count active skills"

if [ -f "$REGISTRY" ]; then
  registry_count=$(jq '.skills | length' "$REGISTRY" 2>/dev/null || echo 0)
  if [ "$registry_count" -eq "$skill_count" ]; then
    ok "registry.json up to date ($registry_count entries)"
  else
    warn "registry.json has $registry_count entries but $skill_count skills exist — run ./build.sh"
  fi
else
  warn "registry.json not found — run ./build.sh"
fi

# ── 4. Global symlinks ────────────────────────────────────────────────────────

section "Global symlinks"

for target in ~/.agents/skills ~/.claude/skills ~/.codex/skills; do
  expanded="${target/#\~/$HOME}"
  if [ ! -e "$expanded" ]; then
    fail "$target: missing"
  elif [ ! -L "$expanded" ]; then
    warn "$target: exists but is not a symlink"
  else
    link_target=$(readlink "$expanded")
    if [ "$link_target" = "$SKILLS_DIR" ]; then
      ok "$target: symlink → $SKILLS_DIR"
    else
      warn "$target: symlink points to $link_target (expected $SKILLS_DIR)"
    fi
  fi
done

# ── 5. Hooks installed in current project ─────────────────────────────────────

section "Hooks in current project"

PROJECT_HOOKS_DIR="$PWD/.claude/hooks"
PROJECT_SETTINGS="$PWD/.claude/settings.json"

if [ "$PWD" = "$AGENT_CONFIG_DIR" ]; then
  ok "Running from agent-config root — skipping project hook check"
else
  hook_count=0
  for hook_file in "$HOOKS_DIR"/*.sh; do
    hook_name=$(basename "$hook_file")
    [[ "$hook_name" == test-* ]] && continue
    if [ -f "$PROJECT_HOOKS_DIR/$hook_name" ]; then
      ((hook_count++)) || true
    fi
  done

  if [ "$hook_count" -eq 0 ]; then
    warn "No hooks installed in $PWD/.claude/hooks/ — run install-hooks.sh"
  else
    ok "$hook_count hook(s) installed in project"
  fi

  if [ -f "$PROJECT_SETTINGS" ]; then
    ok ".claude/settings.json present"
  else
    warn ".claude/settings.json missing — run install-hooks.sh"
  fi
fi

# ── 6. Prompts installed in VS Code ──────────────────────────────────────────

section "VS Code prompts"

if [ ! -d "$VSCODE_PROMPTS_DIR" ]; then
  warn "VS Code user prompts folder not found: $VSCODE_PROMPTS_DIR"
else
  installed=0
  missing=()
  for prompt_file in "$PROMPTS_DIR"/*.prompt.md; do
    prompt_name=$(basename "$prompt_file")
    if [ -f "$VSCODE_PROMPTS_DIR/$prompt_name" ] || [ -L "$VSCODE_PROMPTS_DIR/$prompt_name" ]; then
      ((installed++)) || true
    else
      missing+=("$prompt_name")
    fi
  done

  total=$(ls "$PROMPTS_DIR"/*.prompt.md 2>/dev/null | wc -l | tr -d ' ')
  ok "$installed/$total prompts installed in VS Code"
  if [ ${#missing[@]} -gt 0 ] && [ "$BRIEF" = false ]; then
    for m in "${missing[@]}"; do
      warn "  not installed: $m"
    done
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "────────────────────────────────"
echo -e "${bold}Diagnose summary:${reset} ${green}$pass ok${reset}  ${yellow}$warn warn${reset}  ${red}$fail fail${reset}"

if [ $fail -gt 0 ]; then
  echo "Run ./validate.sh for detailed failure messages."
  exit 1
fi
echo ""
