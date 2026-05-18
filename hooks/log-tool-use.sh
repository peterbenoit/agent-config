#!/bin/bash
# log-tool-use.sh
#
# Appends a one-liner to .agent-session.log every time the agent writes a file
# or runs a bash command. Designed for use as a Claude Code PostToolUse hook.
#
# Claude Code delivers PostToolUse hook input as JSON on stdin:
#   {
#     "tool_name": "...",
#     "tool_input": { ... },
#     "tool_response": { ... }
#   }
#
# This hook extracts tool_name and a brief description and appends to the log.
# Requires: jq (falls back to naive parsing without it)
#
# Install for a single project:
#   mkdir -p .claude/hooks
#   cp ~/GitHub/agent-config/hooks/log-tool-use.sh .claude/hooks/
#   chmod +x .claude/hooks/log-tool-use.sh
#
# Add to .claude/settings.json:
#   {
#     "hooks": {
#       "PostToolUse": [
#         {
#           "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/log-tool-use.sh" }]
#         }
#       ]
#     }
#   }
#
# Note: The PostToolUse hook has no matcher field — it fires for all tools.
# The log file is .agent-session.log in the project root (CLAUDE_PROJECT_DIR).
# Add .agent-session.log to .gitignore if you don't want it committed.

set -euo pipefail

PAYLOAD=$(cat)

LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.agent-session.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if command -v jq &>/dev/null; then
  TOOL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_name // "unknown"')
  # Extract a short description per tool type
  case "$TOOL" in
    Bash)
      DETAIL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // ""' | head -c 120)
      ;;
    Write|create_file|edit_file|replace_string_in_file|multi_replace_string_in_file)
      DETAIL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.path // .tool_input.filePath // ""')
      ;;
    Read|read_file)
      DETAIL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.path // .tool_input.filePath // ""')
      ;;
    *)
      DETAIL=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input | keys | join(", ")' 2>/dev/null || echo "")
      ;;
  esac
else
  TOOL=$(printf '%s' "$PAYLOAD" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/')
  DETAIL=""
fi

printf '[%s] %-30s %s\n' "$TIMESTAMP" "$TOOL" "$DETAIL" >> "$LOG_FILE"

exit 0
