#!/bin/bash
# agent-config/test-scripts.sh
#
# Integration tests for init.sh, update.sh, and validate.sh.
# Runs against temporary directories — no changes to the real repo.
#
# Usage:
#   ./test-scripts.sh
#
# Exit code 0 = all tests passed. Non-zero = failures.

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_SH="$AGENT_CONFIG_DIR/init.sh"
UPDATE_SH="$AGENT_CONFIG_DIR/update.sh"
VALIDATE_SH="$AGENT_CONFIG_DIR/validate.sh"

pass=0
fail=0

# ── Helpers ───────────────────────────────────────────────────────────────────

ok()   { echo "  ok    $1"; pass=$((pass + 1)); }
fail() { echo "  FAIL  $1"; fail=$((fail + 1)); }

# Create a temp project dir, run a block inside it, then clean up.
# Usage: with_tmp_project <label> <body function>
with_tmp_project() {
  local label="$1"
  local tmp
  tmp=$(mktemp -d)
  pushd "$tmp" > /dev/null
  "$2" "$label" "$tmp"
  popd > /dev/null
  rm -rf "$tmp"
}

assert_exists()   { [ -e "$1" ] && ok "$2: $1 exists" || fail "$2: expected $1 to exist"; }
assert_missing()  { [ ! -e "$1" ] && ok "$2: $1 absent" || fail "$2: expected $1 to be absent"; }
assert_contains() { grep -qF "$2" "$1" && ok "$3: '$2' in $1" || fail "$3: '$2' not found in $1"; }
assert_exit0()    { "$@" &>/dev/null && ok "exit 0: $*" || fail "expected exit 0: $*"; }
assert_exit1()    { "$@" &>/dev/null; [ $? -ne 0 ] && ok "exit non-0: $*" || fail "expected non-0 exit: $*"; }

echo ""
echo "agent-config script tests"
echo ""

# ── init.sh ───────────────────────────────────────────────────────────────────

echo "── init.sh: blank project"
_init_blank() {
  local label="$1"
  bash "$INIT_SH" &>/dev/null
  assert_exists "skills" "$label"
  assert_exists "AGENTS.md" "$label"
  assert_contains "AGENTS.md" "## Skills" "$label"
  assert_contains "AGENTS.md" ".local.md" "$label"
}
with_tmp_project "init blank" _init_blank

echo ""
echo "── init.sh: existing AGENTS.md is not overwritten"
_init_existing_agents() {
  local label="$1"
  echo "# My Existing AGENTS" > AGENTS.md
  bash "$INIT_SH" &>/dev/null
  assert_contains "AGENTS.md" "My Existing AGENTS" "$label"
}
with_tmp_project "init existing AGENTS.md" _init_existing_agents

echo ""
echo "── init.sh: existing skills/ is not overwritten"
_init_existing_skills() {
  local label="$1"
  mkdir -p skills
  echo "sentinel" > skills/sentinel.txt
  bash "$INIT_SH" &>/dev/null
  assert_exists "skills/sentinel.txt" "$label"
}
with_tmp_project "init existing skills/" _init_existing_skills

echo ""
echo "── init.sh: --dry-run creates nothing"
_init_dry_run() {
  local label="$1"
  bash "$INIT_SH" --dry-run &>/dev/null
  assert_missing "skills" "$label"
  assert_missing "AGENTS.md" "$label"
}
with_tmp_project "init dry-run" _init_dry_run

echo ""
echo "── init.sh: self-run guard"
_init_self_guard() {
  local label="$1"
  pushd "$AGENT_CONFIG_DIR" > /dev/null
  bash "$INIT_SH" &>/dev/null
  [ $? -ne 0 ] && ok "$label: exits non-0 when run from agent-config itself" \
                || fail "$label: should refuse to run inside agent-config"
  popd > /dev/null
}
_init_self_guard "init self-guard"

# ── update.sh ─────────────────────────────────────────────────────────────────

echo ""
echo "── update.sh: adds new skills"
_update_adds_new() {
  local label="$1"
  # Simulate a project with only skills/ and one skill copied
  bash "$INIT_SH" &>/dev/null
  # Remove one skill to simulate it being new
  first_skill=$(ls skills/ | grep -v README | head -1)
  rm -rf "skills/$first_skill"
  bash "$UPDATE_SH" &>/dev/null
  assert_exists "skills/$first_skill" "$label"
}
with_tmp_project "update adds new skills" _update_adds_new

echo ""
echo "── update.sh: skips locally modified SKILL.md"
_update_skips_modified() {
  local label="$1"
  bash "$INIT_SH" &>/dev/null
  first_skill=$(ls skills/ | grep -v README | head -1)
  echo "# local modification" >> "skills/$first_skill/SKILL.md"
  output=$(bash "$UPDATE_SH" 2>&1)
  echo "$output" | grep -q "skipped" \
    && ok "$label: modified skill is reported as skipped" \
    || fail "$label: expected 'skipped' in output for modified skill"
  assert_contains "skills/$first_skill/SKILL.md" "local modification" "$label"
}
with_tmp_project "update skips modified" _update_skips_modified

echo ""
echo "── update.sh: --force overwrites modified SKILL.md"
_update_force_overwrites() {
  local label="$1"
  bash "$INIT_SH" &>/dev/null
  first_skill=$(ls skills/ | grep -v README | head -1)
  echo "# local modification" >> "skills/$first_skill/SKILL.md"
  bash "$UPDATE_SH" --force &>/dev/null
  grep -q "local modification" "skills/$first_skill/SKILL.md" \
    && fail "$label: --force should have overwritten local modification" \
    || ok "$label: --force overwrote modified SKILL.md"
}
with_tmp_project "update force overwrites" _update_force_overwrites

echo ""
echo "── update.sh: .local.md overlays are never touched"
_update_preserves_local_overlay() {
  local label="$1"
  bash "$INIT_SH" &>/dev/null
  first_skill=$(ls skills/ | grep -v README | head -1)
  echo "# my overlay" > "skills/$first_skill.local.md"
  bash "$UPDATE_SH" --force &>/dev/null
  assert_exists "skills/$first_skill.local.md" "$label"
  assert_contains "skills/$first_skill.local.md" "my overlay" "$label"
}
with_tmp_project "update preserves .local.md overlays" _update_preserves_local_overlay

echo ""
echo "── update.sh: --dry-run makes no changes"
_update_dry_run() {
  local label="$1"
  bash "$INIT_SH" &>/dev/null
  first_skill=$(ls skills/ | grep -v README | head -1)
  rm -rf "skills/$first_skill"
  bash "$UPDATE_SH" --dry-run &>/dev/null
  assert_missing "skills/$first_skill" "$label"
}
with_tmp_project "update dry-run" _update_dry_run

echo ""
echo "── update.sh: symlinked skills/ exits early"
_update_symlink_guard() {
  local label="$1"
  ln -sf "$AGENT_CONFIG_DIR/skills" ./skills
  output=$(bash "$UPDATE_SH" 2>&1)
  echo "$output" | grep -qi "symlink\|always current" \
    && ok "$label: symlink guard triggered" \
    || fail "$label: expected symlink guard message"
}
with_tmp_project "update symlink guard" _update_symlink_guard

# ── validate.sh ───────────────────────────────────────────────────────────────

echo ""
echo "── validate.sh: passes on clean repo"
output=$(bash "$VALIDATE_SH" 2>&1)
echo "$output" | grep -q "All checks passed" \
  && ok "validate clean repo: passes" \
  || fail "validate clean repo: expected 'All checks passed'"

echo ""
echo "── validate.sh: fails on skill with bad frontmatter"
_validate_bad_frontmatter() {
  local label="$1"
  # Copy the real skills dir so validate.sh works, then corrupt one skill
  cp -r "$AGENT_CONFIG_DIR/skills" ./skills
  cp -r "$AGENT_CONFIG_DIR/prompts" ./prompts
  cp -r "$AGENT_CONFIG_DIR/instructions" ./instructions
  cp -r "$AGENT_CONFIG_DIR/context" ./context
  cp -r "$AGENT_CONFIG_DIR/templates" ./templates
  cp "$AGENT_CONFIG_DIR/init.sh" ./init.sh
  cp "$AGENT_CONFIG_DIR/validate.sh" ./validate.sh
  chmod +x ./validate.sh
  echo "no frontmatter here" > skills/qa/SKILL.md
  output=$(bash ./validate.sh 2>&1)
  echo "$output" | grep -q "FAIL" \
    && ok "$label: bad frontmatter caught" \
    || fail "$label: expected FAIL for missing frontmatter"
}
with_tmp_project "validate bad frontmatter" _validate_bad_frontmatter

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "────────────────────────────────"
total=$((pass + fail))
echo "$pass/$total passed"

if [ $fail -gt 0 ]; then
  echo "$fail failed."
  exit 1
fi

echo "All tests passed."
echo ""
