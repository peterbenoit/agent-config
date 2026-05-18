#!/bin/bash
# hooks/test-check-test-before-commit.sh
#
# Fixture tests for check-test-before-commit.sh.
# Run from the repo root or hooks/ directory.
#
# Usage:
#   ./hooks/test-check-test-before-commit.sh
#
# Exit code 0 = all tests passed. Non-zero = failures.

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/check-test-before-commit.sh"

if [ ! -x "$HOOK" ]; then
  echo "ERROR: hook not found or not executable: $HOOK"
  exit 1
fi

pass=0
fail=0

TMPDIR_TEST=$(mktemp -d)
cleanup() { rm -rf "$TMPDIR_TEST"; }
trap cleanup EXIT

# ── Helpers ───────────────────────────────────────────────────────────────────

payload() { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }

assert_blocked() {
  local label="$1"
  local payload="$2"
  if printf '%s' "$payload" | CLAUDE_PROJECT_DIR="$TMPDIR_TEST" "$HOOK" &>/dev/null; then
    echo "  FAIL  should be BLOCKED: $label"
    fail=$((fail + 1))
  else
    echo "  ok    blocked: $label"
    pass=$((pass + 1))
  fi
}

assert_allowed() {
  local label="$1"
  local payload="$2"
  if printf '%s' "$payload" | CLAUDE_PROJECT_DIR="$TMPDIR_TEST" "$HOOK" &>/dev/null; then
    echo "  ok    allowed: $label"
    pass=$((pass + 1))
  else
    echo "  FAIL  should be ALLOWED: $label"
    fail=$((fail + 1))
  fi
}

# ── Non-commit commands always pass through ───────────────────────────────────

echo ""
echo "── check-test-before-commit.sh tests — non-commit passthrough"

assert_allowed "git status"        "$(payload 'git status')"
assert_allowed "git push"          "$(payload 'git push origin main')"
assert_allowed "npm install"       "$(payload 'npm install')"
assert_allowed "ls"                "$(payload 'ls -la')"

# ── --no-verify bypasses the hook ────────────────────────────────────────────

echo ""
echo "── check-test-before-commit.sh tests — --no-verify bypass"

assert_allowed "git commit --no-verify" "$(payload 'git commit --no-verify -m \"skip\"')"

# ── No test runner: warn but allow ───────────────────────────────────────────

echo ""
echo "── check-test-before-commit.sh tests — no test runner"

# Empty project dir (no package.json, no test files)
assert_allowed "git commit with no test runner" "$(payload 'git commit -m \"initial\"')"

# ── Passing tests: allow commit ───────────────────────────────────────────────

echo ""
echo "── check-test-before-commit.sh tests — passing tests"

# Create a package.json with a test script that passes
cat > "$TMPDIR_TEST/package.json" << 'EOF'
{
  "name": "test-project",
  "scripts": {
    "test": "exit 0"
  }
}
EOF

assert_allowed "git commit when tests pass" "$(payload 'git commit -m \"all green\"')"

# ── Failing tests: block commit ───────────────────────────────────────────────

echo ""
echo "── check-test-before-commit.sh tests — failing tests"

cat > "$TMPDIR_TEST/package.json" << 'EOF'
{
  "name": "test-project",
  "scripts": {
    "test": "exit 1"
  }
}
EOF

assert_blocked "git commit when tests fail" "$(payload 'git commit -m \"broken\"')"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
