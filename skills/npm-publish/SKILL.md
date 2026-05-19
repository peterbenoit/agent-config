---
name: npm-publish
category: Code Quality
tags: [npm, publish, semver, esm, cjs, package, registry, changelog, @peterbenoit]
updated: 2026-05-18
triggers: ["dual ESM CJS","npm pack","npm publish","package.json exports","publish to npm","semver","version bump","what version should this be"]
description: >
  Manage the npm package publish lifecycle for scoped packages. Use when preparing to publish
  or update an npm package, choosing a version bump, writing a CHANGELOG entry, setting up
  dual ESM/CJS output, auditing package.json exports, or running a pre-publish checklist.
  Trigger on phrases like "publish to npm", "version bump", "semver", "npm publish",
  "package.json exports", "dual ESM CJS", "what version should this be", "pre-publish
  checklist", "npm pack", or any task about releasing or maintaining an npm package.
---

# npm Publish Specialist

You are the npm publish specialist. You know the full lifecycle from code change to registry.
Your job is to make sure nothing broken ships and nothing necessary is missing from the package.

---

## Package Conventions (@peterbenoit scope)

All packages are scoped under `@peterbenoit`. Format: `@peterbenoit/package-name`.

Required `package.json` fields:

```json
{
  "name": "@peterbenoit/package-name",
  "version": "1.0.0",
  "description": "One sentence. What it does.",
  "type": "module",
  "main": "./dist/index.cjs",
  "module": "./dist/index.js",
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "require": "./dist/index.cjs"
    }
  },
  "files": ["dist", "README.md", "LICENSE"],
  "scripts": {
    "build": "...",
    "test": "node --test",
    "prepublishOnly": "npm test && npm run build"
  },
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/peterbenoit/package-name"
  },
  "keywords": [],
  "engines": { "node": ">=18" }
}
```

---

## Semver

| Change type | Bump | Example |
|-------------|------|---------|
| Bug fix, no API change | patch | 1.2.3 → 1.2.4 |
| New feature, backward compatible | minor | 1.2.3 → 1.3.0 |
| Breaking change | major | 1.2.3 → 2.0.0 |
| Pre-release / experimental | prerelease | 1.2.3 → 1.3.0-beta.1 |

**When in doubt, ask:**
- Does any existing call site break without changes? → major
- Did anything new become possible? → minor
- Is this a pure fix? → patch

Do not increment the major version for internal refactors. Do not ship a minor that silently
changes observable behavior — that is a major.

---

## Dual ESM/CJS Output

Most bundlers handle this. The pattern with a build tool (e.g., tsup, rollup, esbuild):

```js
// tsup.config.js
export default {
  entry: ['src/index.js'],
  format: ['esm', 'cjs'],
  dts: true,              // only if TypeScript
  clean: true,
};
```

After build, verify:
- `dist/index.js` — ESM (`import/export` syntax)
- `dist/index.cjs` — CJS (`require`/`module.exports`)
- Both are in `files` field and listed in `exports` map

Test both:
```bash
node -e "const m = require('./dist/index.cjs'); console.log(typeof m)"
node --input-type=module -e "import m from './dist/index.js'; console.log(typeof m)"
```

---

## Pre-Publish Checklist

Run through this in order. Do not publish if any item fails.

**Code**
- [ ] All tests pass (`npm test`)
- [ ] No uncommitted changes (`git status`)
- [ ] Build is current (`npm run build`)

**Package.json**
- [ ] `version` bumped correctly for the change
- [ ] `main`, `module`, and `exports` all point to files that exist in `dist/`
- [ ] `files` array includes `dist/`, `README.md`, `LICENSE` — and nothing else sensitive
- [ ] `peerDependencies` declared if this uses a framework the consumer provides
- [ ] `engines.node` set to the minimum you've actually tested against

**Content**
- [ ] `README.md` reflects the current API (no outdated examples)
- [ ] `CHANGELOG.md` has an entry for this version with today's date
- [ ] `LICENSE` file is present (MIT)

**Dry run**
```bash
npm pack --dry-run
```
Read the output. Confirm only expected files are included. Flag anything surprising.

**Publish**
```bash
npm publish --access public   # for scoped packages (required first time)
npm publish                   # subsequent publishes
```

For pre-releases:
```bash
npm publish --tag beta
```

---

## CHANGELOG Format

Use Keep a Changelog format. Entry goes at the top under `## [Unreleased]` until publish,
then the heading becomes `## [x.y.z] — YYYY-MM-DD`.

```markdown
## [Unreleased]

## [1.2.0] — 2026-05-18

### Added
- New `options.timeout` parameter

### Fixed
- Crash when input array is empty

### Changed
- Default debounce increased from 100ms to 200ms
```

Never write "various bug fixes" or "minor improvements". Name what changed.

---

## After Publishing

- Tag the release: `git tag v1.2.0 && git push --tags`
- Create a GitHub release with the CHANGELOG entry as the body
- Verify on npmjs.com that the correct files are in the package
- Test install in a fresh directory: `npm install @peterbenoit/package-name` and run a
  smoke test against the just-published version

---

## Common Failures

**403 on publish** — not logged in, or the package name is taken. `npm whoami` to check login.
**Package too large** — something in `files` or `.npmignore` is wrong. `npm pack --dry-run`.
**`require()` fails on ESM package** — `exports` map doesn't have a `require` condition.
**`import` fails on CJS-only package** — no `module` field or ESM entry in `exports`.
**Consumer gets wrong version** — they have it cached. `npm install @peterbenoit/pkg@latest`.

---

## Project Context

Check AGENTS.md or a local `skills/npm-publish.local.md` overlay for:
- Which registry (npmjs.com or a private registry)
- CI/CD publish workflow (manual or automated on tag push)
- Any peer dependency constraints
- Links to existing published packages for consistency reference
