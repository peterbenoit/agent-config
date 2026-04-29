# hooks/

Shell scripts for agent hook systems.

---

## What This Is

Hooks are scripts that run automatically at specific points in an agent session — before a tool
executes, after a file is written, when a session ends. They're the enforcement layer: rules
that can't be ignored because they run outside the agent's control.

Skills tell an agent what to do. Hooks prevent the agent from doing things it shouldn't,
regardless of what it was told.

---

## Hook Systems by Agent

Different agent environments support different hook mechanisms:

**Claude Code** — `PreToolUse` hooks run before any bash command. Configured in
`.claude/settings.json` per project or `~/.claude/settings.json` globally. The hook script
receives the command and can block it by exiting non-zero.

**GitHub Copilot / VSCode** — No native hook system. Enforced via `AGENTS.md` instructions
instead. Less reliable than a real hook, but the only option in this environment.

**Cursor** — Similar to VSCode; rule-based enforcement via instruction files rather than
executable hooks.

---

## Scripts in This Folder

Scripts here are reusable and project-agnostic. Copy or symlink them into a project when needed.

| Script | Purpose | Compatible With |
|--------|---------|-----------------|
| `block-dangerous-git.sh` | Blocks destructive git commands | Claude Code |

To add a new hook script:
1. Write it as a standalone shell script with a clear name
2. Make it executable: `chmod +x hooks/your-script.sh`
3. Document it in the table above
4. Add usage instructions below

---

## block-dangerous-git.sh

Intercepts bash commands and blocks patterns that could cause irreversible data loss:
`git push`, `git reset --hard`, `git reset --soft`, `git clean`, `git branch -D`,
`git rebase`, `git checkout --force`, `git stash drop`.

When blocked, the agent sees a message telling it the command is not permitted and to ask
the user to run it manually.

**Install for a single project:**

```bash
mkdir -p .claude/hooks
cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh .claude/hooks/
chmod +x .claude/hooks/block-dangerous-git.sh
```

Then add to `.claude/settings.json` (merge with existing — don't overwrite):
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

**Install globally (all projects):**

```bash
mkdir -p ~/.claude/hooks
cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/block-dangerous-git.sh
```

Then add to `~/.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Adjusting the blocked list:** Edit the `DANGEROUS_PATTERNS` array in the script before
installing. The `git-guardrails` skill walks through this if you want agent-assisted setup.

---

## Writing a New Hook

A hook script receives context via environment variables (Claude Code exposes `$BASH_COMMAND`,
`$CLAUDE_PROJECT_DIR`, and others). It should:

1. Read the relevant context
2. Check against its rules
3. Exit `0` to allow the action, exit `1` to block it with a message to stdout

Keep hooks focused. One concern per script. A hook that does too much becomes hard to debug
when something unexpected gets blocked.
