---
name: doc-sync
description: Enforces documentation hygiene when working in agent-config. Every code change must be reflected in CHANGELOG, README, AGENTS.md, and CLAUDE.md before the session ends.
applyTo: "**"
---

# Documentation Sync Rules for agent-config

This is the meta-repo. Documentation drift here means every downstream project inherits stale instructions. Keep docs current as you go.

## The Four Files That Must Stay in Sync

| File | Update when |
|------|------------|
| `CHANGELOG.md` | Any code change — always, no exceptions |
| `README.md` | New/removed scripts, changed flags, skill count change, new context files or templates |
| `AGENTS.md` | New/removed scripts, skill count, new context files, templates, prompts, instructions |
| `CLAUDE.md` | `## Key Scripts` section changes |

## VERSION

`VERSION` contains the current release number (`major.minor.patch`). Bump it when cutting a release:
- Move `## [Unreleased]` to `## [X.Y.Z] — YYYY-MM-DD` in CHANGELOG
- Add a fresh empty `## [Unreleased]` above it
- Write the new version to `VERSION`

Rules:
- `patch` (0.2.x) — any commit that changes code, docs, or skills. Default bump. If in doubt, patch.
- `minor` (0.x.0) — new skills, new scripts, new flags, new prompts or templates
- `major` (x.0.0) — breaking changes to init.sh/update.sh behavior, skill format changes

Do not leave VERSION stale across sessions. Every session that produces a commit should produce a version bump.

## CHANGELOG Rules

Every session must write at least one entry under `## [Unreleased]`.

Format:
```markdown
### Added
- `script-name` — one-line description of what it does

### Changed
- `file.sh`: flag or behavior change, one line

### Fixed
- short description of what was wrong and what was corrected
```

Write the entry **immediately** after the change, not at end of session. If you make five changes, write five entries. Do not batch and write at the end.

## README Rules

The `README.md` Structure section must match the actual files in the repo root. Check:
- Is the new script listed?
- Does the `init.sh` description reflect current flags?
- Does the `update.sh` description reflect current flags?
- Does `skills/` show the correct skill count?
- Is the skills trigger table complete?
- Are context files listed?

## AGENTS.md Rules

The bullet list under `## What This Repo Is` must match actual files. Check:
- Scripts: `build.sh`, `completion.sh`, `diagnose.sh`, `setup.sh`, `list.sh`, `search.sh`, `new-skill.sh`, `init.sh`, `update.sh`, `install-hooks.sh`, `install-instructions.sh`
- Skill count in `skills/` bullet
- Template count in `templates/` bullet

## CLAUDE.md Rules

`## Key Scripts` must list every script a developer would run in a session. If a script is added to the repo, it goes here.

## Enforcement

After completing any code change, before moving to the next task, ask:
1. What changed?
2. Which of the four docs need updating?
3. Update them now.

Do not defer doc updates. Do not batch them for the end of the session. The backlog item is not done until the docs reflect it.
