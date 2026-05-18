# @<!-- scope -->/<!-- package-name -->

<!-- One sentence: what this package does. Be specific — "wraps X to do Y" not just "a utility". -->

## Skills

Agent skills are in `./skills/`. For this project, the most relevant skills are:
`npm-publish`, `tdd`, `debug`, `security`, `npm-safety`.

To add project-specific context, create a local overlay: `./skills/<name>.local.md`.

## Package Info

```json
{
  "name": "@<!-- scope -->/<!-- package-name -->",
  "version": "<!-- current version -->",
  "type": "module"
}
```

Registry: `<!-- npmjs.com / private registry URL -->`
Published at: `https://www.npmjs.com/package/@<!-- scope -->/<!-- package-name -->`

## Semver Rules

| Change | Bump |
|--------|------|
| Bug fix, no API change | patch |
| New feature, backward compatible | minor |
| Breaking change | major |

When in doubt: does any existing call site break without changes? → major.

## Build

```bash
npm run build     # compile dist/
npm test          # run test suite (must pass before publish)
npm pack --dry-run  # verify package contents before publishing
```

Output: `<!-- dist/ or lib/ -->`
Formats: `<!-- ESM only / CJS only / dual ESM+CJS -->`

## Publish Workflow

```bash
# 1. Confirm tests pass
npm test

# 2. Bump version
npm version patch   # or minor / major

# 3. Dry run — verify files
npm pack --dry-run

# 4. Publish
npm publish --access public

# 5. Tag and push
git push --tags

# 6. Create GitHub release with CHANGELOG entry
```

## Exports Map

```json
{
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "require": "./dist/index.cjs"
    }
  }
}
```

<!-- Adjust if the package has named sub-exports or a single format. -->

## Files Published

The `files` field in package.json controls what ships:
```json
{ "files": ["dist", "README.md", "LICENSE"] }
```

Confirm with `npm pack --dry-run` before every publish. Nothing in `src/`,
`node_modules/`, `.env`, or test files should appear in the output.

## Dependencies

Runtime dependencies: `<!-- list or "none" -->`
Peer dependencies: `<!-- list or "none" — what the consumer must provide -->`
Dev dependencies: test runner, build tool, linting only.

Never add a runtime dependency without flagging it. Prefer native browser/Node APIs.

## Test Runner

```bash
<!-- node --test / vitest / jest — specify what's in use -->
```

Tests live alongside source: `src/index.test.js` or `src/__tests__/`.
Every published function must have test coverage.

## CHANGELOG

Format: Keep a Changelog (`## [x.y.z] — YYYY-MM-DD`).
Never write "various fixes". Name every change.

## Hard Rules

- Bump version before publish — never republish the same version
- `npm pack --dry-run` before every `npm publish`
- All tests pass before publish (`prepublishOnly` script enforces this)
- No secrets in package source or published files
- `LICENSE` file present (MIT unless otherwise decided)
