# Changelog

All notable changes to agent-config are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `goal-setting` skill (Workflow) — goal clarification, decomposition, next-action definition
- `vads` skill (Accessibility) — VA Design System component selection, implementation rules, deviation process
- `drupal.md` context file — hook system, config management, Twig theming, entity/bundle glossary, drush commands
- `va-gov.md` context file — VADS, USWDS, 508, GTM/GA4 data layer, vets-website vs content-build, Flipper flags
- `search.sh` — search skills by name, category, tags, or description
- `new-skill.sh` — scaffold a new skill directory and SKILL.md stub
- `list.sh` — list all skills with category and description (`--json` for machine-readable output)
- `CHANGELOG.md` — this file
- `SECURITY.md` — responsible disclosure policy
- `VERSION` — version tracking file (`0.1.0`)
- `CLAUDE.md` — Claude Code session config at repo root (auto-loaded, points to AGENTS.md)
- `.claude/settings.json` — wires `block-dangerous-git.sh` as a PreToolUse hook for Claude Code
- `category:` and `tags:` frontmatter fields on all 21 skill SKILL.md files
- Symlink health check in `validate.sh` section 10
- `category:` and `tags:` validation in `validate.sh` skill frontmatter checks
- `npm-safety` added to `skills/README.md` and root `README.md` (was missing)
- `skills/.system/` documented in `skills/README.md` as Codex-managed, not agent-config skills

### Changed
- `AGENTS.md` updated: skill count (19 → 21), context list, new scripts documented
- `new-skill.prompt.md` updated: `category:` and `tags:` added to required frontmatter template
- `validate.sh` now checks prompts, context files, templates, symlinks, and `category`/`tags` fields

---

## [0.1.0] — 2026-05-18

Initial tracked state. Skills, hooks, prompts, instructions, templates, and context files
established. `validate.sh`, `init.sh`, and `update.sh` functional.

### Skills
508, analytics, bigcommerce, content-strategy, design, git-guardrails, grill-me,
new-blog-post, new-project-page, npm-safety, og-images, performance, qa, security,
seo, social, tdd, voice, zoom-out

### Hooks
- `block-dangerous-git.sh` with fixture test

### Prompts
- announce, new-skill, pre-publish, weekly-review

### Instructions
- accessibility, security, writing

### Templates
- agents-default, agents-bigcommerce, agents-federal-app, agents-js-library,
  agents-static-site, agents-web-app
