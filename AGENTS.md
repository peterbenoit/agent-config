# AGENTS.md — agent-config

This is the meta-repo: the source of truth for reusable agent skills, hook scripts, context
files, and AGENTS.md templates that get deployed into other projects. When working here, you
are editing the toolkit, not a project that uses it.

---

## What This Repo Is

- `skills/` — Universal SKILL.md files. 21 active skills, 2 deferred.
- `prompts/` — `.prompt.md` slash commands for VS Code chat (`/pre-publish`, `/new-skill`, `/announce`, `/weekly-review`, `/diagnose`).
- `instructions/` — `.instructions.md` always-on rules loaded automatically by file pattern (accessibility, security, writing).
- `hooks/` — Shell scripts for Claude Code PreToolUse hooks.
- `context/` — Domain briefing files for BigCommerce, JS libraries, static sites, federal apps, web apps, Drupal, VA.gov.
- `templates/` — AGENTS.md starters for 6 project types.
- `validate.sh` — Checks skill frontmatter, README tables, hook executability, symlinks, and heredoc sync.
- `list.sh` — List all skills with category and description (`--json` for machine-readable output).
- `search.sh` — Search skills by name, category, tags, or description.
- `new-skill.sh` — Scaffold a new skill directory and SKILL.md stub.
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
