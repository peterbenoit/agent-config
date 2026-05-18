#!/bin/bash
# check-test-before-commit.sh
#
# Blocks `git commit` commands if the project's test suite is failing.
# Enforces TDD discipline at the hook layer.
#
# Claude Code delivers PreToolUse hook input as JSON on stdin:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }
#
# Requires: jq (falls back to naive parsing without it)
#
# Install for a single project:
#   mkdir -p .claude/hooks
#   cp ~/GitHub/agent-config/hooks/check-test-before-commit.sh .claude/hooks/
#   chmod +x .claude/hooks/check-test-before-commit.sh
#
# Add to .claude/settings.json (merge with existing hooks):
#   {
#     "hooks": {
#       "PreToolUse": [
#         {
#           "matcher": "Bash",
#           "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-test-before-commit.sh" }]
#         }
#       ]
#     }
#   }
#
# Test runner detection order:
#   1. package.json "test" script → npm test
#   2. node --test (if test files exist)
#   3. No test runner found → warn but allow
#
# To skip this check for a specific commit, pass --no-verify:
#   git commit --no-verify -m "..."
# This hook does not intercept --no-verify commits.

set -euo pipefail

PAYLOAD=$(cat)

if command -v jq &>/dev/null; then
  COMMAND=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // empty')
else
  COMMAND=$(printf '%s' "$PAYLOAD" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/')
fi

# Only fire on git commit commands (not git commit --no-verify)
if ! printf '%s' "$COMMAND" | grep -qE 'git[[:space:]]+commit'; then
  exit 0
fi

if printf '%s' "$COMMAND" | grep -q '\-\-no\-verify'; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# ── Detect test runner ────────────────────────────────────────────────────────

TEST_CMD=""

if [ -f "$PROJECT_DIR/package.json" ]; then
  if command -v jq &>/dev/null; then
    HAS_TEST=$(jq -r '.scripts.test // empty' "$PROJECT_DIR/package.json")
  else
    HAS_TEST=$(grep -o '"test"[[:space:]]*:[[:space:]]*"[^"]*"' "$PROJECT_DIR/package.json" | head -1)
  fi
  if [ -n "$HAS_TEST" ] && [ "$HAS_TEST" != "echo \"Error: no test specified\" && exit 1" ]; then
    TEST_CMD="npm test --prefix \"$PROJECT_DIR\""
  fi
fi

# Fallback: check for Node built-in test files
if [ -z "$TEST_CMD" ]; then
  if find "$PROJECT_DIR" -name "*.test.js" -o -name "*.spec.js" 2>/dev/null | grep -q .; then
    TEST_CMD="node --test --test-reporter=spec"
  fi
fi

if [ -z "$TEST_CMD" ]; then
  # No test runner found — warn but allow the commit
  echo "WARNING: check-test-before-commit — no test runner detected. Allowing commit."
  echo "Add a 'test' script to package.json to enforce test-before-commit."
  exit 0
fi

# ── Run tests ─────────────────────────────────────────────────────────────────

echo "check-test-before-commit: running test suite before commit..."

if (cd "$PROJECT_DIR" && eval "$TEST_CMD" 2>&1); then
  echo "Tests passed. Proceeding with commit."
  exit 0
else
  echo ""
  echo "BLOCKED: Tests are failing. Fix them before committing."
  echo "To skip this check (use sparingly): git commit --no-verify"
  exit 1
fi
