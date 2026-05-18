---
name: git-guardrails
category: Security
tags: [git, hooks, safety, destructive-commands, pre-commit, guardrails]
updated: 2026-05-18
description: >
  Set up hooks to block dangerous git commands before they execute. Use when the user wants to
  prevent destructive git operations, add git safety rails, or protect against accidental
  git push, reset --hard, clean, or branch deletion in an agentic session. Trigger on phrases
  like "git guardrails", "block git push", "prevent accidental git", "git safety",
  "hook to stop git", or "protect against reset --hard".
---

# Git Guardrails

Blocks dangerous git commands before they execute by installing a pre-execution hook.

Blocked by default: `push`, `reset --hard`, `reset --soft`, `clean`, `branch -D`, `branch -d`,
`rebase`, `checkout --force`, `restore --staged` (in bulk), `stash drop`.

---

## For Claude Code (PreToolUse hook)

Ask the user: install for this project only (`.claude/settings.json`) or all projects
(`~/.claude/settings.json`)?

Copy the canonical hook script from `hooks/block-dangerous-git.sh` in agent-config.
Do not recreate it inline — the canonical file is the source of truth for the blocked list.

```bash
mkdir -p .claude/hooks
cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh .claude/hooks/
chmod +x .claude/hooks/block-dangerous-git.sh
```

The hook reads the command from Claude Code's stdin JSON payload (requires `jq`).
If `jq` is not installed: `brew install jq`.

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

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Whether to install project-scoped (`.claude/settings.json`) or globally (`~/.claude/settings.json`)
- Any project-specific commands to add to the blocked list beyond the defaults
- Whether this project has a CI environment where the hook should not apply
