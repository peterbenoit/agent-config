#!/bin/bash
# block-dangerous-git.sh
#
# Intercepts bash commands and blocks destructive git operations.
# Designed for use as a Claude Code PreToolUse hook.
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

COMMAND="$BASH_COMMAND"

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git reset --soft"
  "git clean"
  "git branch -D"
  "git branch -d"
  "git rebase"
  "git checkout --force"
  "git stash drop"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -q "$pattern"; then
    echo "BLOCKED: You do not have authority to run '$pattern' in this session."
    echo "Ask the user to run this command manually if it is genuinely needed."
    exit 1
  fi
done

exit 0
