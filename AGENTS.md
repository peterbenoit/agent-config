# AGENTS.md — agent-config

This is the meta-repo: the source of truth for reusable agent skills, hook scripts, context
files, and AGENTS.md templates that get deployed into other projects. When working here, you
are editing the toolkit, not a project that uses it.

---

## What This Repo Is

- `skills/` — Universal SKILL.md files. 18 active skills, 2 in progress.
- `hooks/` — Shell scripts for Claude Code PreToolUse hooks.
- `context/` — Domain briefing files for BigCommerce, JS libraries, static sites, web apps.
- `templates/` — AGENTS.md starters for 6 project types.
- `init.sh` — Wires agent-config into a new project (copy or symlink + starter AGENTS.md).
- `update.sh` — Pulls skill updates into an already-initialized project.

---

## Conventions

### Skills

Every skill is a `SKILL.md` file in `skills/<name>/SKILL.md`.

Required YAML frontmatter:
```yaml
---
name: skill-name
description: >
  One paragraph. What role this plays, when to load it, and 4–6 trigger phrases.
  Specificity matters — vague descriptions cause false triggers or missed triggers.
---
```

**The description field is load-bearing.** Agents read it to decide whether to load the skill.
If you can't write a description that clearly distinguishes when to use this vs not, the scope
is not well-defined yet.

**Universal means universal.** A skill belongs here only if it works without modification in
any project. Strip out any hardcoded URLs, file paths, property IDs, project names, or
site-specific known issues. Those go in a `## Project Context` section that instructs the agent
to check the project's AGENTS.md or a local overlay.

### Hooks

Hook scripts must be standalone and project-agnostic. They are copied or symlinked into
projects — do not hardcode paths or assume any project structure.

Document every script in `hooks/README.md` with: purpose, compatible agent environments,
install instructions, and any limitations.

### Templates

Templates use HTML comment placeholders for everything project-specific:
`<!-- Project name -->`, `<!-- Describe the architecture -->`, etc.

Placeholders are invisible to agents until replaced, so a template can serve as a working
skeleton immediately after copying.

Each template must be documented in `templates/README.md`.

### Context files

Files in `context/` are domain briefings — background knowledge about a technology or platform
that agents can read for orientation. They are not instructions; they're reference material.

---

## Adding a New Skill

1. `mkdir skills/<name> && touch skills/<name>/SKILL.md`
2. Write the YAML frontmatter (see format above)
3. Write the body: role definition, methodology, principles, checklists, examples
4. Add it to the table in `skills/README.md`
5. Add a row to the skills table in the root `README.md`
6. Ask before shipping: would this need editing before it's useful in a different project? If
   yes, extract the project-specific parts into a `## Project Context` section.

---

## What Not to Do Here

- Do not add skills that only work for one project — those live in that project's repo
- Do not add hardcoded URLs, credentials, or project names to universal skills
- Do not modify `init.sh` without verifying the heredoc AGENTS.md it generates still matches
  `templates/agents-default.md`
- Do not use `--force` with `update.sh` without reading what local overlays will be overwritten
