# CLAUDE.md — agent-config

This file is loaded automatically by Claude Code in every session inside this repo.
The full agent manifest is in `AGENTS.md` — read that first.

---

## What This Repo Is

This is the meta-repo for reusable agent skills, hooks, prompts, instructions, and
AGENTS.md templates. When Claude Code is working here, it is editing the toolkit itself,
not a project that uses the toolkit.

**The most important rule:** skills, hooks, and instructions here must stay universal.
Strip any project-specific content before committing. If something only works for one
project, it belongs in that project's overlay, not here.

---

## Hook Configuration

This repo uses `block-dangerous-git.sh` as a PreToolUse hook for Claude Code sessions.
Configuration lives in `.claude/settings.json`.

If that file is missing, install it:
```bash
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
EOF
```

---

## Key Scripts

```bash
./validate.sh              # full health check — run before committing
./build.sh                 # regenerate registry.json after skill changes
./completion.sh            # generate shell tab completions (--install-zsh / --install-bash)
./list.sh                  # list all skills with category and description
./list.sh --json           # machine-readable skill list
./search.sh <query>        # search skills by name, category, tags, or description
./new-skill.sh <name>      # scaffold a new skill directory and SKILL.md stub
./init.sh                  # wire agent-config into a target project
./update.sh                # pull skill updates into an already-initialized project
```

---

## Before Committing

1. Run `./validate.sh` — all checks must pass
2. Confirm any new skill has `name:`, `category:`, `tags:`, and `updated:` in its frontmatter
3. Confirm any new skill is listed in `skills/README.md` and root `README.md`
4. Confirm any new context file is listed in `context/README.md`
5. Confirm any new template is listed in `templates/README.md`
6. Update `CHANGELOG.md` under `## [Unreleased]`
7. Update `README.md`, `AGENTS.md`, and `CLAUDE.md` if scripts or counts changed

---

## What Not to Do

- Do not add project-specific URLs, file paths, or credentials to any skill
- Do not edit `skills/.system/` — those are Codex-managed system skills
- Do not set `agent: agent` on a prompt that only reads and reports (use `ask`)
- Do not modify `init.sh` without verifying the heredoc still matches `templates/agents-default.md`
- Do not use `--force` with `update.sh` without understanding it overwrites local skill edits
