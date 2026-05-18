#!/bin/bash
# hooks/test-block-file-writes.sh
#
# Fixture tests for block-file-writes.sh.
# Run from the repo root or hooks/ directory.
#
# Usage:
#   ./hooks/test-block-file-writes.sh
#
# Exit code 0 = all tests passed. Non-zero = failures.

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/block-file-writes.sh"

if [ ! -x "$HOOK" ]; then
  echo "ERROR: hook not found or not executable: $HOOK"
  exit 1
fi

pass=0
fail=0

# ── Helpers ───────────────────────────────────────────────────────────────────

payload_write() { printf '{"tool_name":"Write","tool_input":{"path":"%s"}}' "$1"; }
payload_bash()  { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }
payload_read()  { printf '{"tool_name":"Read","tool_input":{"path":"%s"}}' "$1"; }

assert_blocked() {
  local label="$1"
  local payload="$2"
  if printf '%s' "$payload" | "$HOOK" &>/dev/null; then
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
  if printf '%s' "$payload" | "$HOOK" &>/dev/null; then
    echo "  ok    allowed: $label"
    pass=$((pass + 1))
  else
    echo "  FAIL  should be ALLOWED: $label"
    fail=$((fail + 1))
  fi
}

# ── Blocked: Write tool on sensitive paths ────────────────────────────────────

echo ""
echo "── block-file-writes.sh tests — Write tool"

assert_blocked ".env"                "$(payload_write '.env')"
assert_blocked ".env.local"          "$(payload_write '.env.local')"
assert_blocked ".env.production"     "$(payload_write '.env.production')"
assert_blocked ".env.staging"        "$(payload_write '.env.staging')"
assert_blocked ".netrc"              "$(payload_write '.netrc')"
assert_blocked "private key .pem"    "$(payload_write 'certs/server.pem')"
assert_blocked "private key .key"    "$(payload_write 'certs/server.key')"
assert_blocked "secrets/ directory"  "$(payload_write 'secrets/api-key.txt')"
assert_blocked "path with credentials" "$(payload_write 'config/credentials.json')"

# ── Blocked: Bash redirects to sensitive paths ────────────────────────────────

echo ""
echo "── block-file-writes.sh tests — Bash redirects"

assert_blocked "echo redirect to .env"  "$(payload_bash 'echo TOKEN=abc > .env')"
assert_blocked "cat redirect to .env.local" "$(payload_bash 'cat base.env >> .env.local')"

# ── Allowed: Normal file paths ────────────────────────────────────────────────

echo ""
echo "── block-file-writes.sh tests — allowed paths"

assert_allowed "src/index.js"         "$(payload_write 'src/index.js')"
assert_allowed "README.md"            "$(payload_write 'README.md')"
assert_allowed ".env.example"         "$(payload_write '.env.example')"
assert_allowed "config/settings.json" "$(payload_write 'config/settings.json')"
assert_allowed "Read tool passthrough" "$(payload_read '.env')"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
