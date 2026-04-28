---
name: git-guardrails
description: >
  Set up hooks to block dangerous git commands before they execute. Use when the user wants to
  prevent destructive git operations, add git safety rails, or protect against accidental
  git push, reset --hard, clean, or branch deletion in an agentic session.
---

# Git Guardrails

Blocks dangerous git commands before they execute by installing a pre-execution hook.

Blocked by default: `push`, `reset --hard`, `reset --soft`, `clean`, `branch -D`, `branch -d`,
`rebase`, `checkout --force`, `restore --staged` (in bulk), `stash drop`.

---

## For Claude Code (PreToolUse hook)

Ask the user: install for this project only (`.claude/settings.json`) or all projects
(`~/.claude/settings.json`)?

Create the script at `.claude/hooks/block-dangerous-git.sh`:

```bash
#!/bin/bash
# Block dangerous git commands in Claude Code sessions

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
```

Make it executable: `chmod +x .claude/hooks/block-dangerous-git.sh`

Add to `.claude/settings.json` (merge if file exists — do not overwrite other settings):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

---

## For VSCode / Copilot (without Claude Code hooks)

PreToolUse hooks are Claude Code-specific. For VSCode/Copilot sessions, add this to AGENTS.md:

```markdown
## Git Safety Rules

NEVER run these git commands without explicit user confirmation in the chat:
- `git push` (any variant)
- `git reset --hard` or `git reset --soft`
- `git clean` (any variant)
- `git branch -D` or `git branch -d`
- `git rebase`
- `git stash drop`

If any of these are required to complete a task, STOP and ask the user first.
State exactly what command you want to run and why. Wait for a "yes" before proceeding.
```

---

Ask the user if they want to adjust the blocked list before installing.
