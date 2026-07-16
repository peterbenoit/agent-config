# agent-config — What It Is and How to Use It

## What this repo is

A collection of "expert modes" for AI agents. When you're working with Claude Code
and ask it to debug something, audit for accessibility, write SEO copy, etc. — the
skills in this repo make it dramatically better at those specific things.

It also includes safety rules (hooks) that run automatically to prevent the AI from
doing things you'd regret.

---

## The two things that matter

### Skills
Files that teach AI agents how to do specific jobs well. When you ask Claude to do
something, it reads the relevant skill and behaves like a specialist instead of a
generalist.

**You don't invoke them manually.** Claude reads each skill's description and loads
it automatically when what you're asking matches.

### Hooks
Shell scripts that run automatically during Claude Code sessions.

Examples of what they do:
- Block `git push`, `git reset --hard`, and other dangerous git commands
- Block writes to `.env` files and secrets directories
- Block `git commit` if tests are failing
- Log everything the agent touches to a session log

---

## Is it already set up?

Check this:

```bash
ls -la ~/.claude/skills
ls -la ~/.codex/skills
```

If those exist and point to your agent-config folder — **skills are already globally
available** to Claude Code and Codex. You don't need to do anything else for skills.

If they're missing, run:

```bash
~/GitHub/agent-config/setup.sh
```

---

## Hooks — the one thing that isn't automatic

Skills work globally once setup.sh ran. **Hooks do not.** They need to be wired up
separately.

You have two options:

### Option A — Hooks for all Claude Code sessions (recommended)

```bash
# Copy the hook scripts to your global Claude folder
mkdir -p ~/.claude/hooks
cp ~/GitHub/agent-config/hooks/block-dangerous-git.sh ~/.claude/hooks/
cp ~/GitHub/agent-config/hooks/block-file-writes.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Create or update ~/.claude/settings.json with this content:
```

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
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/block-file-writes.sh"
          }
        ]
      }
    ]
  }
}
```

This protects every project, every session, automatically.

### Option B — Hooks for one specific project

Run this from inside that project:

```bash
~/GitHub/agent-config/install-hooks.sh
```

---

## Starting a new project

When you start working in a new codebase and want the AI to know about it:

```bash
cd ~/path/to/your/project
~/GitHub/agent-config/init.sh
```

This drops an `AGENTS.md` file in the project that tells Claude what it's working
with and which skills apply.

Optional flags:
- `--with-hooks` — also wire hooks into this project
- `--template drupal` — use the Drupal-specific AGENTS.md starter instead of the default
- `--select seo,tdd,security` — only install the skills you actually need

---

## Status check — run this anytime

```bash
~/GitHub/agent-config/diagnose.sh
```

Tells you: are symlinks healthy, are hooks installed, how many skills are active,
is everything in sync.

---

## What each script does (quick reference)

| Script | What it does |
|--------|-------------|
| `setup.sh` | One-time global setup — creates symlinks so agents can find skills |
| `init.sh` | Sets up a new project with skills and an AGENTS.md |
| `update.sh` | Updates skills in an existing project to the latest versions |
| `install-hooks.sh` | Wires hooks into a project |
| `validate.sh` | Health check for the agent-config repo itself |
| `diagnose.sh` | Full system health check — run this when something seems off |
| `list.sh` | Show all available skills |
| `search.sh "keyword"` | Find skills matching a topic |

---

## Summary

| Goal | What to do |
|------|-----------|
| Skills work in all Claude Code sessions | Run `setup.sh` once |
| Hooks protect all Claude Code sessions | Copy hooks to `~/.claude/hooks/` and update `~/.claude/settings.json` |
| Set up a new project | Run `init.sh` from inside that project |
| Check if everything is working | Run `diagnose.sh` |
