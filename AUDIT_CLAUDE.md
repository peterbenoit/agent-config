# agent-config Audit Report
_Generated May 2026_

---

## Summary

This is a well-built, genuinely useful repo — the result of real iteration, not just theorizing. The skill system, overlay pattern, and hook conventions are all sound. The main drift is Brick City Creative specifics leaking into universal files, and complexity built for Claude Code that doesn't fully transfer to your actual daily workflow.

---

## What's Working Well

**The skill frontmatter system is solid.** The `name`, `category`, `tags`, `triggers`, `requires`, and `updated` convention is genuinely useful. The `triggers:` array being machine-readable (rather than embedded in prose) is smarter than the previous approach. The `build.sh` → `registry.json` pipeline is the right call for machine-readable discovery.

**The overlay pattern (`.local.md`) is the best idea in the repo.** Keeping universal base skills separate from project-specific context, and protecting overlays from `update.sh` overwrites, solves a real problem cleanly. It's the right abstraction.

**The hooks are appropriately scoped.** `block-dangerous-git.sh`, `block-file-writes.sh`, `check-test-before-commit.sh`, and `log-tool-use.sh` each do one thing. The fixture test convention — every hook ships with a `test-*.sh` — is good discipline worth keeping.

**`validate.sh` is comprehensive.** It checks frontmatter completeness, category validity, trigger phrase counts, README coverage, template placeholder presence, and symlink health in one pass. This is the kind of quality gate that prevents drift.

---

## Honest Concerns

### 1. The repo is optimized for Claude Code, but you use claude.ai and VS Code Copilot

The skills, hooks, and `CLAUDE.md` are wired for Claude Code's `PreToolUse`/`PostToolUse` hook system. For your actual primary workflow — claude.ai and VS Code Copilot — the operative layer is just the `AGENTS.md` content and `.instructions.md` files. **The hooks don't fire at all in those environments.**

Worth being clear-eyed: roughly 40% of the repo's complexity (the entire `hooks/` directory, `.claude/settings.json`, `log-tool-use.sh`, `block-file-writes.sh`, `check-test-before-commit.sh`) provides zero value in your daily workflow. The hooks are good — they're just not connected to anything you're actually using.

**Recommendation:** Either document this gap explicitly in `CLAUDE.md` / `README.md` ("hooks only apply in Claude Code sessions"), or deprioritize hooks work until Claude Code becomes a primary tool.

---

### 2. `goal-setting` skill has your name baked in

`skills/goal-setting/SKILL.md` references "Pete" throughout — "Help Pete set, clarify...", "When Pete mentions a goal...", "Pete has a dry sense of humor." This is a universal skill repo. Any project initialized from it inherits a skill that addresses someone else by name.

**Recommendation:** Generalize (replace "Pete" with "the user") and move the Pete-specific voice notes into a `skills/goal-setting.local.md` overlay in your personal projects. Or move the whole skill to `~/.agents/skills/custom/` where you've already documented the convention for exactly this case.

---

### 3. `discovery` and `handoff` skills reference "Brick City Creative" directly

Both skills have "Brick City Creative" in their frontmatter `tags` and `description` fields, and their bodies are written for that specific client engagement context. These are good skills — they're just not universal. They're project-specific skills wearing universal clothing.

**Recommendation:** Move them to a Brick City Creative project repo as local skills, or add a clear caveat to their frontmatter that they're agency-specific and will need editing before use elsewhere. Their descriptions currently claim universal applicability ("Use this skill when starting a new client engagement") which is misleading for anyone else using this repo.

---

### 4. The `docs` skill is listed in `skills/README.md` but doesn't exist

The table in `skills/README.md` lists `docs` with the description "README writing, API documentation structure, changelogs" — but there is no `skills/docs/` directory and no `SKILL.md`. This is a silent gap. `validate.sh` catches the reverse (skills that exist but aren't listed) but not this direction.

**Recommendation:** Either create the skill (it's a genuine gap — `voice` handles prose quality, but documentation architecture is different) or remove the row from the table. Creating it would be the more useful option.

---

### 5. `validate.sh` doesn't reverse-check `skills/README.md`

The validator confirms every active skill directory is listed in `skills/README.md`, but not the reverse: that every entry in the README table points to a real skill directory. The `docs` gap above is the live example of why this matters.

**Recommendation:** Add a reverse check — for each `\`skill-name\`` entry found in the README table, verify a corresponding `SKILL.md` exists. One `grep` + loop, likely under 10 lines.

---

### 6. `IMPROVEMENTS.md` is 87+ items complete and becoming noise

The backlog has been worked down extensively — the vast majority of items are checked. A file with 87 completed items and ~3 open ones is not a backlog anymore, it's an archive. Reading through it to find what's actually open requires scanning past enormous amounts of completed work.

**Recommendation:** Archive the completed content (or delete it — it's all in `CHANGELOG.md` anyway) and keep only the open items. Or replace the whole file with a much shorter `TODO.md` containing just the remaining work.

---

### 7. `WHATS_LEFT.md` is a stale session note

It's a note-to-self ("6 items left, and they're all related...") written during a session. The items it describes are now checked off in `IMPROVEMENTS.md`. It has no ongoing utility.

**Recommendation:** Delete it.

---

### 8. The `.system/` skills are substantial noise

The `imagegen`, `openai-docs`, `plugin-creator`, `skill-creator`, and `skill-installer` directories are OpenAI Codex-managed system skills. They're documented as "don't touch" — but they're enormous. The `imagegen` skill alone contains thousands of lines of Python across multiple scripts. They take up space in a repo you read and maintain.

If you're not actively using OpenAI Codex, these are dead weight.

**Recommendation:** If Codex isn't in your workflow, move the `.system/` directory out of the main repo (or `.gitignore` it). If it is, add a clearer note in the root `README.md` explaining what `.system/` is and why it's there, so it doesn't confuse anyone reading the repo (including future you).

---

### 9. `backlog.sh` is hardcoded to `IMPROVEMENTS.md`

There's a comment in the script itself acknowledging the problem: the human wants it to be less specific to `IMPROVEMENTS.md`. The script could easily look for any file matching `IMPROVEMENTS.md`, `TODO.md`, `BACKLOG.md`, or search for a `## Backlog` section in whatever file exists.

**Recommendation:** Generalize the script. Make the filename configurable via an argument, defaulting to a detection pass (`IMPROVEMENTS.md` → `TODO.md` → `BACKLOG.md` → first file with a `## Backlog` heading).

---

## What's Missing

### A "cold-start" orientation skill or prompt

There's no skill or prompt for "how do I use this toolkit itself." A new session always has to re-orient: which skill should I invoke? What does the overlay pattern look like? How do I add a new context file? The information exists, but it's spread across `AGENTS.md`, `CLAUDE.md`, `README.md`, and `skills/README.md`.

A `/toolkit` prompt or a `meta` skill — even 30 lines — would make cold-starts faster. Something that says: here's what exists, here's how to invoke it, here's what to check first.

### The relationship between this repo and your user skills isn't documented

Your project-specific skills (Brick City Creative creative director, web designer, copywriter, project manager, etc.) live in `/mnt/skills/user/` — outside this repo. The `README.md` mentions `~/.agents/skills/custom/` as the convention for personal non-universal skills, but the actual location and what's there isn't documented anywhere in this repo. Someone reading this repo (or a future session) has no way to know those skills exist or where to find them.

**Recommendation:** Add a brief section to `README.md` or `AGENTS.md` noting the personal skills location and what's there. Even just: "Project-specific and personal skills live at `~/.agents/skills/custom/` — not tracked here."

---

## Prioritized Action List

### High value, low effort

| # | Action |
|---|--------|
| 1 | Delete `WHATS_LEFT.md` |
| 2 | Generalize `goal-setting` skill — replace "Pete" with "the user" |
| 3 | Add a caveat or move `discovery` and `handoff` (Brick City Creative-specific) |
| 4 | Fix the `docs` entry in `skills/README.md` — create the skill or remove the row |
| 5 | Archive completed items in `IMPROVEMENTS.md`, keep only open ones |

### Medium effort, real payoff

| # | Action |
|---|--------|
| 6 | Add reverse coverage check to `validate.sh` (README entries → actual skill dirs) |
| 7 | Generalize `backlog.sh` to work with any backlog filename |
| 8 | Document the personal/user skills location in `README.md` |
| 9 | Add a `/toolkit` prompt or `meta` skill for cold-start orientation |

### Worth thinking about

| # | Action |
|---|--------|
| 10 | Decide what to do with `.system/` — document it better or move it out if Codex isn't in your workflow |
| 11 | Acknowledge the Claude Code vs. claude.ai gap in `README.md` — clarify which features apply where |
| 12 | Create the `docs` skill — documentation architecture is genuinely different from `voice` and would fill a real gap |

---

_This report was generated from a full read of the repo contents. No files were modified._
