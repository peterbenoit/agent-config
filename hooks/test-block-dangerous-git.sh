#!/bin/bash
# hooks/test-block-dangerous-git.sh
#
# Fixture tests for block-dangerous-git.sh.
# Run from the repo root or hooks/ directory.
#
# Usage:
#   ./hooks/test-block-dangerous-git.sh
#
# Exit code 0 = all tests passed. Non-zero = failures.

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/block-dangerous-git.sh"

if [ ! -x "$HOOK" ]; then
  echo "ERROR: hook not found or not executable: $HOOK"
  exit 1
fi

pass=0
fail=0

# ── Helpers ───────────────────────────────────────────────────────────────────

# Build a minimal Claude Code PreToolUse JSON payload
payload() { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }

# Assert hook blocks the command (exit 1)
assert_blocked() {
  local cmd="$1"
  local label="${2:-$1}"
  if printf '%s' "$(payload "$cmd")" | "$HOOK" &>/dev/null; then
    echo "  FAIL  should be BLOCKED: $label"
    fail=$((fail + 1))
  else
    echo "  ok    blocked: $label"
    pass=$((pass + 1))
  fi
}

# Assert hook allows the command (exit 0)
assert_allowed() {
  local cmd="$1"
  local label="${2:-$1}"
  if printf '%s' "$(payload "$cmd")" | "$HOOK" &>/dev/null; then
    echo "  ok    allowed: $label"
    pass=$((pass + 1))
  else
    echo "  FAIL  should be ALLOWED: $label"
    fail=$((fail + 1))
  fi
}

# Assert hook blocks when command has extra whitespace
assert_blocked_ws() {
  local cmd="$1"
  local label="${2:-$1}"
  assert_blocked "$cmd" "$label (extra whitespace)"
}

echo ""
echo "block-dangerous-git.sh tests"
echo ""

# ── Should be BLOCKED ─────────────────────────────────────────────────────────

echo "── Blocked patterns"
assert_blocked "git push"
assert_blocked "git push origin main"
assert_blocked "git push --force origin main"
assert_blocked "git reset --hard"
assert_blocked "git reset --hard HEAD~1"
assert_blocked "git reset --soft HEAD~1"
assert_blocked "git clean -fd"
assert_blocked "git clean -fdx"
assert_blocked "git branch -D feature/old"
assert_blocked "git branch -d feature/old"
assert_blocked "git rebase main"
assert_blocked "git rebase -i HEAD~3"
assert_blocked "git checkout --force main"
assert_blocked "git restore --staged ."
assert_blocked "git restore --staged src/file.ts"
assert_blocked "git stash drop"
assert_blocked "git stash drop stash@{0}"

echo ""
echo "── Blocked: extra whitespace variants"
# Whitespace normalization — these should still be blocked
assert_blocked_ws "git  push"
assert_blocked_ws "git   push origin main"
assert_blocked_ws "git  reset  --hard"

# ── Should be ALLOWED ─────────────────────────────────────────────────────────

echo ""
echo "── Allowed: safe commands"
assert_allowed "git status"
assert_allowed "git log --oneline -10"
assert_allowed "git diff HEAD"
assert_allowed "git add -p"
assert_allowed "git commit -m 'fix: correct typo'"
assert_allowed "git fetch origin"
assert_allowed "git pull --rebase origin main"
assert_allowed "git stash"
assert_allowed "git stash list"
assert_allowed "git stash pop"
assert_allowed "git branch"
assert_allowed "git branch --list"
assert_allowed "git checkout main"
assert_allowed "git switch main"
assert_allowed "git restore src/file.ts"
assert_allowed "cat README.md"

# Known limitation: grep-based matching cannot distinguish a blocked pattern
# that appears inside a string or comment from one being executed. These
# commands will be incorrectly blocked. Documented, not fixed, because
# reliable shell-syntax parsing is out of scope for this hook.
echo "  note  known false positive: echo 'git push would be bad' (blocked, expected)"
echo "  note  known false positive: # git push comment (blocked, expected)"

echo ""
echo "── Allowed: empty/unparseable payload"
# Empty command field — should allow (can't determine intent)
printf '{"tool_name":"Bash","tool_input":{"command":""}}' | "$HOOK" &>/dev/null
if [ $? -eq 0 ]; then
  echo "  ok    allowed: empty command"
  pass=$((pass + 1))
else
  echo "  FAIL  should be ALLOWED: empty command"
  fail=$((fail + 1))
fi

# Missing command field — should allow
printf '{"tool_name":"Bash","tool_input":{}}' | "$HOOK" &>/dev/null
if [ $? -eq 0 ]; then
  echo "  ok    allowed: missing command field"
  pass=$((pass + 1))
else
  echo "  FAIL  should be ALLOWED: missing command field"
  fail=$((fail + 1))
fi

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
