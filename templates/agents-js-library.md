# Package Name

<!-- One paragraph: what this library does, what problem it solves, who uses it, where it runs. -->

Published on npm as `<!-- package-name -->`. Written in <!-- JavaScript / TypeScript -->. Runs in <!-- browser / Node / both -->.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

**Recommended for JS libraries:** `tdd`, `npm-safety`, `npm-publish`, `security`, `qa`

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>.local.md` — the agent reads both; the local file wins on conflicts.
Do not edit `SKILL.md` directly — it will be overwritten on updates.

## Context

If this project has a CONTEXT.md in the root, read it before starting any task.
It defines domain-specific terms, key system relationships, and decisions that should
not be silently reversed. AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
npm run build    # compile src/ → dist/
npm test         # run tests
npm run typecheck  # type-check without emitting
```

<!-- Add any additional commands: docs generation, playground, etc. -->

## Architecture

- `src/index.ts` — public entry point. Only symbols exported here are part of the public API.
- `src/` — source files. Internal modules; consumers import from the package name, not file paths.
- `dist/` — compiled output. <!-- committed to git / in .gitignore — specify which and why -->
- `test/` — tests. Uses <!-- Jest / Vitest / Mocha --> with <!-- jsdom / browser / Node --> environment.

<!-- Describe any non-obvious module relationships or dependencies. -->

## Versioning

This package follows strict semver:
- **Patch:** bug fixes with no behavior change, documentation updates
- **Minor:** new exports, new options with backward-compatible defaults
- **Major:** removed exports, changed defaults, behavioral changes to existing API

When in doubt: major. A surprised consumer is worse than an early major bump.

## What Not to Do

- Never expose internal module paths as part of the public API — import from `src/index.ts` only
- Never commit `.env` files or credentials — use environment variables at runtime
- <!-- Example guardrail (replace or remove): Never add a runtime dependency without an explicit decision — this is a zero-dependency library -->
- <!-- Example guardrail (replace or remove): Never make delivery behavior async if it is currently synchronous — that changes the observable contract -->
- <!-- Add project-specific guardrails here -->
