---
name: 'context-chooser'
description: 'Inspect the current project and recommend which context file(s) and skills from agent-config to load'
agent: 'ask'
tools: ['search/codebase']
---

Inspect the current project and recommend which context file(s) and skills from agent-config
to load for this session.

## What to Check

Look at the project root for these signals:

- `package.json` — Node.js or npm library? Check `dependencies`, `devDependencies`, `type`, and `bin` field.
- `composer.json` — PHP/Drupal project.
- `drupal.info.yml` or a `web/` folder with Drupal structure — Drupal site.
- `.github/` or AGENTS.md — Is there already an agent context file? What does it say?
- `vite.config.*`, `webpack.config.*` — frontend build tool in use.
- Presence of `*.federal.gov` or references to USWDS, VADS — federal or VA property.
- `*.prompt.md`, `SKILL.md` — this might be an agent-config project itself.
- `README.md` — read the first paragraph for project type signals.

## Context Files Available

From `agent-config/context/`:

| File | When to use |
|------|-------------|
| `bigcommerce.md` | BigCommerce theme or app development |
| `drupal.md` | Drupal CMS projects (any version) |
| `federal-app.md` | Federal government web properties, USWDS, 508 compliance |
| `js-library.md` | Standalone JavaScript libraries and utilities |
| `node-api.md` | Node.js REST APIs and backend services |
| `npm-package.md` | npm package development and publishing |
| `static-site.md` | Static site generators (Eleventy, Jekyll, Hugo, etc.) |
| `va-gov.md` | VA.gov specific — VADS, GA4/GTM, CMS workflows |
| `web-app.md` | General web application with a backend |

## Skills to Suggest

Based on project type, suggest 3-5 relevant skills. Prioritize:

- All projects: `security`, `git-guardrails`, `qa`
- Accessibility-sensitive: `508`, `design`
- Content sites: `seo`, `content-strategy`, `techwriter`
- npm/library: `tdd`, `refactor`, `npm-safety`
- Performance-sensitive: `performance`
- Client-facing: `social`, `og-images`

## Output Format

Report in three sections:

**1. Project type detected:** One sentence. What kind of project this is.

**2. Recommended context files:** List the 1-2 most relevant context files to load, with
a one-line reason for each.

**3. Recommended skills:** List 3-5 skills to activate for this session, with a one-line
reason for each.

If the project is ambiguous or missing key files, say so and ask one clarifying question.
