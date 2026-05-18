---
name: 'diagnose'
description: 'Run a full agent-config health check: validate.sh, symlink status, skill count, and system summary'
agent: 'ask'
---

Run a full health check of the agent-config toolkit.

---

## Steps

1. Run `./validate.sh` and report all failures and warnings. If it passes cleanly, say so.

2. Run `./list.sh` and report:
   - Total skill count
   - Skills by category (grouped)
   - Any skill missing a category (blank entry in the CATEGORY column)

3. Check symlink health: confirm `~/.agents/skills`, `~/.claude/skills`, and `~/.codex/skills`
   all exist and point to the correct source.

4. Check that `.claude/settings.json` exists and contains the `block-dangerous-git.sh` hook.

5. Report the current `VERSION` file contents.

6. Check `CHANGELOG.md` for an `## [Unreleased]` section. If it exists and has entries,
   flag it as a reminder that a release may be pending.

---

## Output Format

Produce a short summary in this structure:

```
validate.sh: [PASS / N failures, N warnings]
Skills: [count] active across [N] categories
Symlinks: [OK / list any missing]
Hook config: [present / missing]
Version: [version string]
Changelog: [Unreleased entries / none pending]
```

Then list any failures or items requiring attention below the summary.
Do not list every passing check — only what needs action.
