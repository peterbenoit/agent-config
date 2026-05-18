#!/bin/bash
# block-file-writes.sh
#
# Blocks agent writes to sensitive file paths: .env files, secrets directories,
# private keys, and credential files. Fires before Write tool calls and before
# bash redirect commands.
#
# Claude Code delivers PreToolUse hook input as JSON on stdin:
#   { "tool_name": "...", "tool_input": { ... } }
#
# Requires: jq (falls back to naive parsing without it)
#
# Install for a single project:
#   mkdir -p .claude/hooks
#   cp ~/GitHub/agent-config/hooks/block-file-writes.sh .claude/hooks/
#   chmod +x .claude/hooks/block-file-writes.sh
#
# Add to .claude/settings.json (merge with existing hooks):
#   {
#     "hooks": {
#       "PreToolUse": [
#         {
#           "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-file-writes.sh" }]
#         }
#       ]
#     }
#   }
#
# Note: Using no matcher fires this hook for ALL PreToolUse events. The hook
# exits 0 immediately for non-write tools to minimize overhead.
#
# Blocked patterns:
#   .env, .env.local, .env.production, .env.* (any dotenv file)
#   *.pem, *.key, *.p12, *.pfx (private keys / certificates)
#   secrets/, .secrets/, private/ (sensitive directories)
#   .netrc, .npmrc (credential files that may contain tokens)
#   *credentials*, *secrets* (filename contains these words)

set -euo pipefail

PAYLOAD=$(cat)

if command -v jq &>/dev/null; then
  TOOL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_name // "unknown"')
else
  TOOL=$(printf '%s' "$PAYLOAD" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/')
fi

# Extract the target path depending on tool type
TARGET=""

case "$TOOL" in
  Write|create_file|edit_file|replace_string_in_file|multi_replace_string_in_file)
    if command -v jq &>/dev/null; then
      TARGET=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.path // .tool_input.filePath // empty')
    else
      TARGET=$(printf '%s' "$PAYLOAD" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/')
    fi
    ;;
  Bash)
    # Check for redirect-to-sensitive-file patterns: echo "..." > .env
    if command -v jq &>/dev/null; then
      CMD=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // empty')
    else
      CMD=$(printf '%s' "$PAYLOAD" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/')
    fi
    # Extract write target from redirect: anything after > or >>
    TARGET=$(printf '%s' "$CMD" | grep -oE '(>>?)[[:space:]]*[^[:space:]]+' | tail -1 | sed 's/^>>*[[:space:]]*//')
    ;;
  *)
    # Not a write-related tool — allow immediately
    exit 0
    ;;
esac

# If no target extracted, allow
if [ -z "$TARGET" ]; then
  exit 0
fi

# Normalize: strip leading path components for basename checks
BASENAME=$(basename "$TARGET")

BLOCKED_PATTERNS=(
  ".env"
  ".env.local"
  ".env.development"
  ".env.production"
  ".env.staging"
  ".env.test"
  ".netrc"
  ".npmrc"
)

# Exact basename matches
for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [ "$BASENAME" = "$pattern" ]; then
    echo "BLOCKED: Writing to '$TARGET' is not permitted."
    echo "Sensitive credential files must not be written by the agent."
    echo "Create or edit this file manually."
    exit 1
  fi
done

# Pattern matches on the full path
SENSITIVE_PATTERNS=(
  "\.env\."          # .env.anything
  "\.pem$"
  "\.key$"
  "\.p12$"
  "\.pfx$"
  "/secrets/"
  "/\.secrets/"
  "/private/"
  "credentials"
  "secrets"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if printf '%s' "$TARGET" | grep -qE "$pattern"; then
    echo "BLOCKED: Writing to '$TARGET' is not permitted."
    echo "The path matches a sensitive pattern ($pattern)."
    echo "If this write is legitimate, do it manually."
    exit 1
  fi
done

exit 0
