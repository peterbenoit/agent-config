# Contributing to agent-config

This is a personal meta-repo for reusable agent skills, hooks, prompts, instructions,
and templates. Contributions from outside collaborators are not expected, but the
conventions are documented here for completeness and for the benefit of agents working
inside the repo.

---

## Quick Reference

```bash
./validate.sh          # full health check — must pass before committing
./build.sh             # regenerate registry.json after skill changes
./list.sh              # list all skills with descriptions
./search.sh <query>    # search skills by name, category, or tags
./new-skill.sh <name>  # scaffold a new skill directory and SKILL.md stub
```

---

## Adding a Skill

1. Run `./new-skill.sh <name>` to create the stub.
2. Fill in all required frontmatter fields:

```yaml
---
name: skill-name
category: Workflow          # Accessibility | Code Quality | Content | Security | Workflow | Meta
tags: [tag1, tag2, tag3]
updated: 2026-01-01
triggers: ["phrase one", "phrase two", "phrase three", "phrase four"]
description: >
  One paragraph. What role this skill plays, when to load it, and what problems it solves.
  Be specific — vague descriptions cause false triggers or missed triggers.
---
```

3. Write the skill body: role definition, methodology, principles, checklists, examples.
4. Add a row to the table in `skills/README.md`.
5. Add a row to the skills table in the root `README.md`.
6. Run `./build.sh` to regenerate `registry.json`.
7. Run `./validate.sh` — all checks must pass.
8. Add an entry under `## [Unreleased]` in `CHANGELOG.md`.

**Universality test**: Would this skill need editing before it's useful in a different
project? If yes, extract the project-specific parts into a `## Project Context` section
that tells the agent to check the project's own AGENTS.md.

---

## Modifying a Skill

1. Run `./validate.sh` first so you know the baseline state.
2. Make your change.
3. Run `./validate.sh` again — all checks must pass.
4. Run `./build.sh` to update `registry.json`.
5. Update `CHANGELOG.md`.

---

## Adding a Prompt

1. Create a `.prompt.md` file in `prompts/`.
2. Required frontmatter: `name`, `description`, and either `agent` or `mode`.
3. Use `mode: ask` for prompts that only read and report — not `agent: agent`.
4. Add a row to `prompts/README.md`.
5. Run `./validate.sh`.

Prompts are not distributed by `init.sh` or `update.sh`. Install manually by copying
or symlinking into the VS Code user prompts folder.

---

## Adding a Context File

1. Create a `.md` file in `context/`.
2. The file must have at least one `#` heading and be non-empty.
3. Add a row to `context/README.md`.
4. Run `./validate.sh`.

---

## Adding a Template

1. Create an `agents-<type>.md` file in `templates/`.
2. Use HTML comment placeholders (`<!-- Project name -->`) for everything project-specific.
3. Add a row to `templates/README.md`.
4. Run `./validate.sh`.

---

## Modifying Hooks

- Every hook must be standalone and project-agnostic.
- After any change, manually test the block and allow cases (see `hooks/README.md`).
- The blocked pattern list in `block-dangerous-git.sh` is the canonical source.
- Document changes in `hooks/README.md` and `CHANGELOG.md`.

---

## Before Committing

- [ ] `./validate.sh` passes with no failures
- [ ] `./build.sh` has been run if skills changed
- [ ] New skills are in both `skills/README.md` and root `README.md`
- [ ] `CHANGELOG.md` updated under `## [Unreleased]`
- [ ] No hardcoded URLs, file paths, or project names in universal files
- [ ] No `skills/.system/` edits (Codex-managed, do not touch)

---

## What Not to Do

- Do not add project-specific content to universal skills
- Do not set `agent: agent` on prompts that only read and report
- Do not modify `init.sh` without verifying the heredoc still matches `templates/agents-default.md`
- Do not use `--force` with `update.sh` without understanding it overwrites local edits
