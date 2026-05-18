# Changelog

All notable changes to agent-config are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `backlog.sh` — shows open IMPROVEMENTS.md items grouped by section with completion percentage; `--all` flag includes completed items

---

## [0.2.0] — 2026-05-18

### Added
- `.github/instructions/doc-sync.instructions.md` — always-on rule enforcing CHANGELOG/README/AGENTS.md/CLAUDE.md updates during sessions in this repo
- `prompts/doc-sync.prompt.md` — `/doc-sync` slash command to audit and sync all four documentation files on demand
- `completion.sh` — generates zsh/bash tab completions for `init.sh` (`--select`, `--template`) and `search.sh`; supports `--install-zsh` and `--install-bash`
- `build.sh` — generates `registry.json` (machine-readable skill index) from SKILL.md frontmatter using `jq`
- `updated: YYYY-MM-DD` frontmatter field added to all 27 SKILL.md files
- `updated:` field included in `registry.json` output from `build.sh`
- `updated:` field validation in `validate.sh` (warns if missing)
- `init.sh` flags: `--select NAME,...` (install only named skills), `--template NAME` (use agents-NAME.md), `--with-hooks` (install block-dangerous-git.sh + .claude/settings.json), `--with-instructions` (copy .instructions.md files to .github/instructions/)
- `init.sh` now writes a `.agent-config` dotfile (source, init_date, skills list) to the target project
- `update.sh` flags: `--with-hooks` (update hooks if present), `--with-instructions` (update instructions if present)
- `setup.sh` extended to wire VS Code prompts dir (individual .prompt.md symlinks) and VS Code instructions dir (individual .instructions.md symlinks)
- `debug` skill (Code Quality) — systematic debugging, hypothesis-driven diagnosis, rubber duck mode
- `npm-publish` skill (Workflow) — npm publish checklist, semver, pre-publish verification
- `css-architecture` skill (Code Quality) — CSS structure, specificity, design tokens, naming conventions
- `discovery` skill (Workflow) — client kickoff, scoping, discovery questions, project intake
- `handoff` skill (Workflow) — project handoff, client documentation, maintenance guides
- `node-api.md` context file — Node.js built-in APIs, streams, fs, http, process
- `npm-package.md` context file — npm package authoring, publishing, scoping, versioning
- `agents-cli-tool.md` template — AGENTS.md starter for CLI tool projects
- `agents-drupal.md` template — AGENTS.md starter for Drupal projects
- `agents-mcp-server.md` template — AGENTS.md starter for MCP server projects
- `agents-npm-package.md` template — AGENTS.md starter for npm package projects
- `accessibility-audit.prompt.md` — on-demand 508/WCAG audit prompt
- `code-review.prompt.md` — structured code review slash command
- `context-chooser.prompt.md` — helps select the right context file for a task
- `diagnose.prompt.md` — system health check slash command
- `new-context.prompt.md` — scaffold a new context file
- `update-skill.prompt.md` — guided skill update workflow
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
- `category:` and `tags:` frontmatter fields on all SKILL.md files
- Symlink health check in `validate.sh` section 10
- `category:` and `tags:` validation in `validate.sh` skill frontmatter checks
- `npm-safety` added to `skills/README.md` and root `README.md` (was missing)
- `skills/.system/` documented in `skills/README.md` as Codex-managed, not agent-config skills

### Changed
- `update.sh` now reports skill version delta: "source: 2026-05-18, installed: 2026-01-10" instead of generic "local changes — skipped" when `updated:` dates differ
- `update.sh` flag parsing changed to `while/shift` to support multi-value flags
- `init.sh` flag parsing changed to `while/shift` to support new flags
- `AGENTS.md` updated: skill count (19 → 27), context list, new scripts documented, template count updated
- `new-skill.prompt.md` updated: `category:` and `tags:` added to required frontmatter template
- `validate.sh` now checks prompts, context files, templates, symlinks, `category`/`tags` fields, `updated:` field, and trigger phrase count

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
