#!/bin/bash
# hooks/test-log-tool-use.sh
#
# Fixture tests for log-tool-use.sh.
# Run from the repo root or hooks/ directory.
#
# Usage:
#   ./hooks/test-log-tool-use.sh
#
# Exit code 0 = all tests passed. Non-zero = failures.

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log-tool-use.sh"

if [ ! -x "$HOOK" ]; then
  echo "ERROR: hook not found or not executable: $HOOK"
  exit 1
fi

pass=0
fail=0

# Use a temp log file so tests don't pollute any real project
TMPDIR_TEST=$(mktemp -d)
export CLAUDE_PROJECT_DIR="$TMPDIR_TEST"
LOG="$TMPDIR_TEST/.agent-session.log"

cleanup() { rm -rf "$TMPDIR_TEST"; }
trap cleanup EXIT

# ── Helpers ───────────────────────────────────────────────────────────────────

payload_bash()  { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }
payload_write() { printf '{"tool_name":"Write","tool_input":{"path":"%s"}}' "$1"; }
payload_read()  { printf '{"tool_name":"Read","tool_input":{"path":"%s"}}' "$1"; }
payload_other() { printf '{"tool_name":"%s","tool_input":{}}' "$1"; }

assert_logs() {
  local label="$1"
  local pattern="$2"
  if grep -q "$pattern" "$LOG" 2>/dev/null; then
    echo "  ok    logged [$label]"
    pass=$((pass + 1))
  else
    echo "  FAIL  not logged [$label] (expected pattern: $pattern)"
    fail=$((fail + 1))
  fi
}

assert_exits_zero() {
  local label="$1"
  local payload="$2"
  if printf '%s' "$payload" | "$HOOK" &>/dev/null; then
    echo "  ok    exits 0: $label"
    pass=$((pass + 1))
  else
    echo "  FAIL  non-zero exit: $label"
    fail=$((fail + 1))
  fi
}

# ── Tests ─────────────────────────────────────────────────────────────────────

echo ""
echo "── log-tool-use.sh tests"

# Always exits 0 (it's a PostToolUse log-only hook)
assert_exits_zero "Bash command" "$(payload_bash 'npm test')"
assert_exits_zero "Write tool" "$(payload_write 'src/index.js')"
assert_exits_zero "Read tool" "$(payload_read 'README.md')"
assert_exits_zero "Unknown tool" "$(payload_other 'SomeTool')"

# Verify entries were written to the log
assert_logs "Bash logged" "Bash"
assert_logs "Write logged" "Write"
assert_logs "Read logged" "Read"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
