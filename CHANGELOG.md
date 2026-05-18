# Changelog

All notable changes to agent-config are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `category:` and `tags:` frontmatter fields to all skill SKILL.md files
- Symlink health check in `validate.sh` (moved from `update.sh`)
- `list.sh` — list all skills with category and description
- `CHANGELOG.md` — this file
- `SECURITY.md` — responsible disclosure policy

### Changed
- `validate.sh` now covers prompts, context files, templates, and symlinks in a single run

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
