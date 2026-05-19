# AGENTS.md — agent-config

This is the meta-repo: the source of truth for reusable agent skills, hook scripts, context
files, and AGENTS.md templates that get deployed into other projects. When working here, you
are editing the toolkit, not a project that uses it.

---

## What This Repo Is

- `skills/` — Universal SKILL.md files. 27 active skills, 2 deferred.
- `prompts/` — `.prompt.md` slash commands for VS Code chat (`/pre-publish`, `/new-skill`, `/announce`, `/diagnose`, `/context-chooser`, and more).
- `instructions/` — `.instructions.md` always-on rules loaded automatically by file pattern (accessibility, security, writing).
- `hooks/` — Shell scripts for Claude Code PreToolUse hooks.
- `context/` — Domain briefing files for BigCommerce, Drupal, JS libraries, Node APIs, npm packages, static sites, federal apps, VA.gov, and web apps.
- `templates/` — AGENTS.md starters for 10 project types.
- `validate.sh` — Checks skill frontmatter, README tables, hook executability, symlinks, and heredoc sync.
- `build.sh` — Generates `registry.json` (machine-readable skill index) from skill frontmatter.
- `backlog.sh` — Shows open items in IMPROVEMENTS.md grouped by section with completion percentage.
- `completion.sh` — Generates zsh/bash tab completions for `init.sh` and `search.sh`.
- `diagnose.sh` — Full system health check: validate, symlinks, registry, hooks, VS Code prompts.
- `setup.sh` — Creates global symlinks and wires VS Code prompts/instructions dirs on a new machine.
- `list.sh` — List all skills with category and description (`--json` for machine-readable output).
- `search.sh` — Search skills by name, category, tags, or description.
- `new-skill.sh` — Scaffold a new skill directory and SKILL.md stub.
- `init.sh` — Wires agent-config into a new project (copy or symlink + starter AGENTS.md).
- `update.sh` — Pulls skill updates into an already-initialized project.
- `install-hooks.sh` — Copies hooks into a target project and wires `.claude/settings.json`.
- `install-instructions.sh` — Copies `.instructions.md` files into a target project.

---

## Conventions

### Skills

Every skill is a `SKILL.md` file in `skills/<name>/SKILL.md`.

Required YAML frontmatter:
```yaml
---
name: skill-name
category: Workflow
tags: [tag1, tag2]
updated: 2026-01-01
triggers: ["phrase one", "phrase two", "phrase three", "phrase four"]
description: >
  One paragraph. What role this plays, when to load it, and what problems it solves.
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

**Deferred skills** have a folder in `skills/` with a `README.md` but no `SKILL.md`. The README
explains why the skill is deferred and what would prompt writing it. `validate.sh` skips folders
without a `SKILL.md`. Deferred skills are listed in `skills/README.md` under the deferred table.
Do not create a stub SKILL.md for a deferred skill — an empty or placeholder SKILL.md is worse
than no file because it may be accidentally loaded.

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

### Prompts

Prompt files (`.prompt.md`) are on-demand slash commands. They must be reusable across
any project — do not hardcode URLs, file paths, or project names in the prompt body.

Required frontmatter fields: `name`, `description`, `agent` (or `mode`).
Document every prompt in `prompts/README.md`.

Do not set `agent: agent` for prompts that only read and report — use `agent: ask` so the
prompt cannot silently modify files.

Installation: copy or symlink `.prompt.md` files into the VS Code user prompts folder
(`~/Library/Application Support/Code/User/prompts/` on macOS). They are not distributed
by `init.sh` or `update.sh` — install manually.

### Instructions

Instruction files (`.instructions.md`) apply automatically whenever the `applyTo` glob
matches the active file. Keep the scope narrow — an instruction that fires on every file
in every session will create noise and override context that doesn't need overriding.

Required frontmatter fields: `name`, `description`, `applyTo`.
Document every instruction in `instructions/README.md`.

Do not put project-specific rules in universal instructions. If a rule only makes sense
for one codebase, it belongs in that project's AGENTS.md or a local `.instructions.md`.

Installation: copy or symlink `.instructions.md` files into the VS Code user instructions
folder or the project's `.github/instructions/` directory. Not distributed by `init.sh`.

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

## Changing the Toolkit

### Before modifying a skill

1. Run `./validate.sh` first so you know the baseline state.
2. Make your change.
3. Run `./validate.sh` again — all checks must still pass.
4. Apply the universality test: would a developer on any project use this unchanged?
   If no, move the project-specific parts into a `## Project Context` section.

### Before modifying `init.sh` or `update.sh`

- Test with `--dry-run` against a scratch directory before running for real.
- If the `init.sh` heredoc changes, verify `./validate.sh` still passes the heredoc check.
- If the behavior changes in a way that affects downstream projects, note what overlays
  may need updating.

### Before modifying `hooks/`

- The hook input contract (stdin JSON from Claude Code) is documented at the top of each
  script. Do not change the input-reading logic without verifying against the Claude Code
  hook spec.
- After any change, manually test the block and allow cases (see `hooks/README.md`).
- The blocked pattern list in `block-dangerous-git.sh` is the canonical source. Do not
  maintain a separate list in skill files.

### Releasing changes to downstream projects

There is no automated distribution. Downstream projects pull updates via `update.sh`.
If a change is breaking (e.g., overlay path convention, frontmatter format), note it
clearly in a commit message. Downstream projects using `--force` will get the update;
safe-mode runs will skip modified files and require manual review.

---

## Task Lists and Backlog Items

When working on any backlog/task file in any repo:

- Items are formatted as `- [ ]` checkboxes
- Mark an item `- [x]` immediately when it is fully complete — not at the end of a session
- Never mark an item complete if it is partially done or only planned
- If you add new items, add them as `- [ ]` checkboxes in the same format
- The checkbox state is the source of truth for what is done and what is not

---

## What Not to Do Here

- Do not add skills that only work for one project — those live in that project's repo
- Do not add hardcoded URLs, credentials, or project names to universal skills
- Do not add project-specific rules to universal instructions — they fire on every file matching
  the `applyTo` pattern across all projects that install them
- Do not set `agent: agent` on a prompt that only reads and reports — use `ask` mode
- Do not modify `init.sh` without verifying the heredoc AGENTS.md it generates still matches
  `templates/agents-default.md`
- Do not use `--force` with `update.sh` without understanding that it overwrites locally
  modified base `SKILL.md` files — `.local.md` overlays are never touched
