#!/bin/bash
# block-dangerous-git.sh
#
# Intercepts bash commands and blocks destructive git operations.
# Designed for use as a Claude Code PreToolUse hook.
#
# Claude Code delivers PreToolUse hook input as JSON on stdin:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }
#
# This script reads that JSON, extracts the command, and blocks any
# command matching a dangerous pattern. Requires: jq
#
# Install for a single project:
#   mkdir -p .claude/hooks
#   cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh .claude/hooks/
#   chmod +x .claude/hooks/block-dangerous-git.sh
#
# Then add to .claude/settings.json (merge — do not overwrite existing settings):
#   {
#     "hooks": {
#       "PreToolUse": [
#         {
#           "matcher": "Bash",
#           "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh" }]
#         }
#       ]
#     }
#   }
#
# Install globally (all Claude Code sessions):
#   mkdir -p ~/.claude/hooks
#   cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh ~/.claude/hooks/
#   chmod +x ~/.claude/hooks/block-dangerous-git.sh
#   # Update ~/.claude/settings.json with the hook config above,
#   # replacing "$CLAUDE_PROJECT_DIR" with the absolute path to the script.

# Read the full hook payload from stdin
PAYLOAD=$(cat)

# Extract the command from the JSON payload.
# Claude Code sends: { "tool_name": "Bash", "tool_input": { "command": "..." } }
if command -v jq &>/dev/null; then
  COMMAND=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // empty')
else
  # Fallback: naive extraction without jq (less reliable).
  # Known limitation: this parser does not handle JSON-escaped quotes correctly.
  # A command containing escaped quotes may be misread, potentially allowing a
  # blocked command through. Install jq to eliminate this risk.
  COMMAND=$(printf '%s' "$PAYLOAD" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/')
fi

# If we couldn't parse a command, allow and let Claude Code handle it
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Normalize whitespace so "git   push" matches the same as "git push"
COMMAND=$(printf '%s' "$COMMAND" | tr -s ' ')

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git reset --soft"
  "git clean"
  "git branch -D"
  "git branch -d"
  "git rebase"
  "git checkout --force"
  "git restore --staged"
  "git stash drop"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qF "$pattern"; then
    echo "BLOCKED: You do not have authority to run '$pattern' in this session."
    echo "Ask the user to run this command manually if it is genuinely needed."
    exit 1
  fi
done

exit 0
