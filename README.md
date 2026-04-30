# agent-config

Personal AI agent toolkit. Skills, hooks, context files, and templates I use across projects.

---

## What This Is

A central library of reusable instructions for AI coding agents (Claude Code, GitHub Copilot,
Cursor, etc.). Skills live here once and get wired into any project that needs them.

**Universal skills** — work in any project, no configuration needed.
**Project-specific skills** — live in the project repo itself, not here.

If a skill references a specific site, codebase, or tool by name, it belongs in that project.
If it would be useful in any project, it belongs here.

---

## Structure

```
agent-config/
├── skills/          # 19 SKILL.md instruction sets + 2 deferred (see skills/README.md)
├── prompts/         # .prompt.md slash commands for VS Code chat (/pre-publish, /new-skill, etc.)
├── instructions/    # .instructions.md always-on rules (accessibility, security, writing)
├── hooks/           # Shell scripts for agent hook systems (Claude Code PreToolUse)
├── context/         # Domain context files (bigcommerce, js-library, static-site, federal, web-app)
├── templates/       # 6 AGENTS.md starters for different project types
├── validate.sh      # Validate skill frontmatter, README tables, hook executability
├── init.sh          # Wire agent-config into a new project (copy or symlink)
└── update.sh        # Pull skill updates into an already-initialized project
```

---

## Wiring a New Project

### Option A — Symlink (local development only)

From inside the project root:

```bash
ln -sf ~/GitHub/agent-config/skills ./skills
```

Then add to `AGENTS.md`:

```markdown
## Skills
Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with instructions
and trigger phrases. Load the relevant skill before starting any matching task.
```

Works on your machine. Does not work in CI, cloud agents, or for collaborators.

### Option B — Copy on init (portable)

```bash
cp -r ~/GitHub/agent-config/skills ./skills
```

Paste-and-forget. Skills are local to the project. Update manually when the source changes.
No portability problems.

### Option C — Setup script

Run from inside any project:

```bash
~/GitHub/agent-config/init.sh
```

This copies the universal skills into `./skills/` and drops a starter `AGENTS.md` if one
doesn't exist. See `init.sh` for what it does before running it.

### Updating skills in an existing project

```bash
~/GitHub/agent-config/update.sh
```

Adds new skills that don't exist yet. Updates skills whose files haven't been locally modified.
Skips skills with local changes and reports them with a diff command to review. Use `--force`
to overwrite all skills including modified ones (will clobber local overlays).

> **Which to use:** Symlink for active projects you own solo. Copy for anything going to CI,
> being shared, or where you want stability over keeping current.

---

## Using Skills

Skills are loaded by the agent when the task matches the trigger phrases in each `description`
field. You don't configure which skills load — the agent reads descriptions and decides.

To use a skill explicitly, just say what you want:

| Skill | Say something like |
|-------|--------------------|
| `508` | "audit this page for 508", "do we need a VPAT" |
| `analytics` | "why did traffic drop", "what does Search Console say" |
| `bigcommerce` | "Stencil template issue", "BC cart API", "storefront API call" |
| `content-strategy` | "what should I write next", "what's missing from this site" |
| `design` | "does this layout feel right", "pick a color for this section" |
| `docs` | "write a README for this", "structure the API docs" |
| `git-guardrails` | "add git safety hooks", "block dangerous git commands" |
| `grill-me` | "grill me on this plan", "stress-test this idea" |
| `new-blog-post` | "start a new blog post", "create a post for..." |
| `new-project-page` | "create a project page for...", "new landing page" |
| `og-images` | "generate OG images", "fix the og:image for this page" |
| `performance` | "why is this page slow", "improve Core Web Vitals" |
| `qa` | "audit this page for accessibility", "review this component" |
| `security` | "audit this for vulnerabilities", "check secrets hygiene" |
| `seo` | "why isn't this page indexed", "write a meta description" |
| `social` | "write a tweet for this", "how do I announce this" |
| `tdd` | "run TDD on this feature", "red-green-refactor this" |
| `voice` | "edit this copy", "does this README sound right" |
| `zoom-out` | "I don't understand this code", "give me the big picture" |

Skills `refactor` and `techwriter` are deferred (README placeholder only, no SKILL.md yet).

---

## Project-Specific Overlays

Universal skills define the role. Project overlays extend them with local context.

**The overlay is a separate file, not a replacement.** When `init.sh` copies skills into a
project, each skill lands at `./skills/<name>/SKILL.md`. Do not edit that file — it is the
universal base and will be overwritten by `update.sh`.

Instead, create an overlay at `./skills/<name>.local.md`. The agent reads both:

```markdown
<!-- skills/seo.local.md -->
Extends the universal SEO skill. Project-specific context:

- Base URL: https://example.com
- Sitemap: auto-generated by vite.config.js on every build
- Known issue: 12 pages currently unindexed — prioritize diagnosis
```

Tell the agent in your `AGENTS.md`:

```markdown
## Skills
Skills are in `./skills/`. Each subfolder has a SKILL.md (universal base).
If a matching `./skills/<name>.local.md` exists, read it after the SKILL.md.
The local file wins on conflicts.
```

Overlays are never overwritten by `update.sh` because they use a different filename.

---

## Adding a New Skill

1. Create `skills/<skill-name>/SKILL.md`
2. Add a frontmatter block at the top:
   ```yaml
   ---
   name: skill-name
   description: >
     One paragraph. What role this plays, when to use it, and 4–6 trigger phrases.
     The description is what the agent reads to decide whether to load this skill.
     Make it specific enough to not false-trigger, broad enough to catch real cases.
   ---
   ```
3. Write the skill body — role definition, principles, workflows, checklists, examples
4. Ask: would this be useful in *any* project, or just this one? If just this one, it belongs
   in that project's repo, not here.

**The description field is load-bearing.** Vague descriptions cause false triggers or missed
triggers. Test it by asking: if an agent read only this description, would it know exactly when
to use this skill and when not to?

---

## What Doesn't Belong Here

- Skills that reference specific URLs, property IDs, file paths, or project names
- Checklists that only make sense for one codebase
- Anything that would need editing before it works in a new project

Those live in the project repo under `skills/` as local overlays or standalone skills.

---

## AGENTS.md vs CLAUDE.md

`AGENTS.md` is the convention used throughout this repo and promoted in the templates. It is
read by Claude Code, GitHub Copilot, and most other agents. Use it.

`CLAUDE.md` is Claude Code's native fallback — Claude reads it when no `AGENTS.md` is present.
You don't need both. `AGENTS.md` takes precedence and covers all agents. If you're working in an
environment that only supports `CLAUDE.md`, create it with the same content.
