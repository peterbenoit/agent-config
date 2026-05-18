---
name: doc-sync
description: Audit and update CHANGELOG.md, README.md, AGENTS.md, and CLAUDE.md to reflect the current state of the repo. Run at the end of any session where code changes were made.
mode: agent
---

Audit the four documentation files in this repo and bring them into sync with the actual codebase. Do not summarize or report — make the edits.

## Step 1: Gather ground truth

Read the following files to understand current repo state:
- List root directory to see all scripts
- `skills/README.md` for current skill count and names
- `context/` directory listing
- `templates/` directory listing
- `prompts/` directory listing
- `instructions/` directory listing

## Step 2: Audit CHANGELOG.md

Read `CHANGELOG.md`. Compare `## [Unreleased]` against any changes made since the last tagged release. Add entries for anything not yet recorded. Do not remove or reorder existing entries.

## Step 3: Audit README.md

Check and update:
1. `## Structure` section: all scripts in repo root must be listed, with accurate descriptions and flags
2. Skill count in `skills/` line (must match actual count from `skills/README.md`)
3. Skills trigger table: every active skill must have a row
4. `init.sh` description: must include all flags (`--select`, `--template`, `--with-hooks`, `--with-instructions`, `--dry-run`, `--force`)
5. `update.sh` description: must include all flags
6. Context files list: all `.md` files in `context/` (excluding `README.md`) must be reflected

## Step 4: Audit AGENTS.md

Check and update:
1. `## What This Repo Is` bullet list: all scripts must be listed with accurate one-line descriptions
2. Skill count in `skills/` bullet
3. Template count in `templates/` bullet

## Step 5: Audit CLAUDE.md

Check and update:
1. `## Key Scripts` block: must list all scripts a developer would run (`validate.sh`, `build.sh`, `completion.sh`, `list.sh`, `search.sh`, `new-skill.sh`, `init.sh`, `update.sh`, `diagnose.sh`, `setup.sh`)

## Step 6: Check VERSION

Read `VERSION`. If any code, docs, or skills changed this session, cut a release:
1. Bump `VERSION` — `patch` by default; `minor` if new skills/scripts/flags/prompts were added; `major` for breaking changes
2. Rename `## [Unreleased]` to `## [X.Y.Z] — YYYY-MM-DD` in CHANGELOG
3. Add a fresh `## [Unreleased]` above it

When in doubt, bump patch. Do not leave VERSION stale.

## Step 7: Verify

Run `./validate.sh` to confirm nothing was broken by the edits.
