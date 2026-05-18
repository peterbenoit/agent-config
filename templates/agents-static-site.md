# Project Name

<!-- One paragraph: what this site is, who it's for, what it does. -->

Static site built with <!-- Vite / Eleventy / plain HTML -->. Deployed on <!-- Netlify / Vercel / GitHub Pages -->.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

**Recommended for static sites:** `seo`, `performance`, `og-images`, `content-strategy`, `qa`

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>.local.md` — the agent reads both; the local file wins on conflicts.
Do not edit `SKILL.md` directly — it will be overwritten on updates.

## Context

If this project has a CONTEXT.md in the root, read it before starting any task.
It defines domain-specific terms, key system relationships, and decisions that should
not be silently reversed. AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
npm run dev      # local dev server
npm run build    # production build → dist/ (or _site/, or public/ — update this)
npm run preview  # preview production build locally
```

<!-- Add any additional build steps: image optimization, type generation, etc. -->

## Architecture

- Source: `src/` (or root — update to match your structure)
- Output: `dist/` — build artifact, never edit manually, not committed to git
- Page registration: <!-- describe how pages are added (vite.config.js rollup inputs, _pages/, etc.) -->
- Assets: <!-- where static assets live and whether they go through the build pipeline -->
- Data files: <!-- source-of-truth data files (JSON, YAML) and what reads them -->

<!-- Describe any non-obvious build pipeline steps: OG image generation, RSS, sitemap, etc. -->

## Deployment

- Deploy command: `<!-- git push / netlify deploy / vercel --prod -->`
- Environment variables: `<!-- list any env vars the build or deploy needs -->`
- Build output directory: `<!-- dist / _site / public -->`

## What Not to Do

- Never edit the build output directory directly — it gets wiped on every build
- Never change a published URL slug without adding a redirect — it breaks inbound links and search indexing
- <!-- Add project-specific guardrails here -->
