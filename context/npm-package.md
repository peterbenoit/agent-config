# CONTEXT — npm Package Development

Building and publishing reusable JavaScript packages to the npm registry. This context
covers the full lifecycle: project setup, module format decisions, versioning, and publishing.
Relevant for any work on standalone libraries, utilities, or CLI tools published under a
scoped registry name.

---

## Glossary

**Scope** — A namespace prefix for a package name, formatted as `@org/package-name`.
Scoped packages can be public or private. All packages here use `@peterbenoit/`.

**`package.json`** — The package manifest. Defines the name, version, entry points, scripts,
dependencies, and what gets included in the published tarball. Every field has a meaning —
do not copy fields from other projects without understanding what they do.

**`main`** — The CommonJS entry point. Used by `require()` in Node.js environments that
don't support the `exports` field.

**`module`** — A non-standard (but widely supported by bundlers) field pointing to the ESM
entry point. Not used by Node.js directly — bundlers like Rollup and Vite read it.

**`exports`** — The modern entry point map. Controls exactly which files are accessible and
under what conditions (`import` vs `require`, `browser` vs `node`). Takes precedence over
`main` and `module` in environments that support it. Required for dual ESM/CJS.

**`files`** — An allowlist of files/directories to include in the published tarball.
If omitted, npm uses `.npmignore` or falls back to including everything. Always set this
explicitly — it prevents publishing `src/`, test files, config files, and secrets.

**`peerDependencies`** — Packages the consumer must provide. Used for framework dependencies
(e.g., if the package wraps a React API, declare React as a peer dep, not a regular dep).
Peer deps are not installed automatically; they show as a warning if missing.

**`devDependencies`** — Dependencies needed only during development: test runners, build tools,
linters. Not installed when a consumer runs `npm install your-package`.

**ESM (ECMAScript Modules)** — The native JavaScript module format. Uses `import`/`export`.
Files use `.js` extension with `"type": "module"` in `package.json`, or `.mjs` extension.

**CJS (CommonJS)** — The legacy Node.js module format. Uses `require()`/`module.exports`.
Files use `.js` with no `"type": "module"`, or `.cjs` extension.

**Dual package** — A package that ships both ESM and CJS output so it works in both
environments without the consumer having to configure anything.

**`prepublishOnly`** — An npm lifecycle script that runs before `npm publish`. Use it to
run tests and build. If it fails, the publish is aborted.

**`npm pack`** — Creates a `.tgz` tarball exactly as npm publish would, without uploading.
Use `npm pack --dry-run` to inspect what would be included without creating the file.

**Semver** — Semantic versioning: `MAJOR.MINOR.PATCH`. Breaking changes → major. New
backward-compatible features → minor. Bug fixes → patch.

**`dist-tag`** — A named pointer to a version. `latest` is the default (what consumers get
with `npm install pkg`). Use `--tag beta` to publish pre-releases without updating `latest`.

---

## Key Relationships

- `package.json` `exports` > `main` > `module` — when all three are present, Node.js uses
  `exports`. Bundlers often prefer `module`. `main` is the legacy fallback.
- `files` is an allowlist, `.npmignore` is a denylist — both can be used, but `files` is
  cleaner and more explicit. If `files` is set, `.npmignore` is ignored for that package.
- `peerDependencies` and `devDependencies` are not the same — peers are the consumer's
  responsibility; devDependencies are yours at build time only.
- `npm version patch` updates `package.json`, commits, and creates a git tag automatically.
  Push with `git push --tags`.

---

## Common Decisions

| Decision | Preferred approach | Why |
|----------|-------------------|-----|
| Module format | Dual ESM + CJS | Works everywhere without consumer config |
| Build tool | tsup or esbuild | Fast, zero-config dual output |
| Test runner | `node --test` for simple; Vitest for complex | No framework overhead for utilities |
| Versioning | `npm version` command | Creates commit + git tag atomically |
| Access | `--access public` on first publish of scoped package | Scoped packages default to private |
| CHANGELOG | Keep a Changelog format | Machine-readable, predictable, easy to diff |

---

## Failure Modes / Gotchas

**`require()` fails on an ESM-only package** — The `exports` map has `"import"` but no
`"require"` condition. Consumers on older Node.js or using CJS tools get an error. Fix: add
CJS output and a `"require"` condition in the exports map.

**Package too large** — A dependency or the whole `src/` directory is being published. Fix:
audit with `npm pack --dry-run`, then correct the `files` field.

**`403 Forbidden` on publish** — Either not logged in (`npm whoami`), or a scoped package
being published without `--access public` for the first time.

**Consumer gets stale version** — npm caches aggressively. Tell them to run
`npm install @scope/pkg@latest` or clear their cache.

**Version tag already exists** — You published `1.2.0` and then tried to `npm version patch`
again without pushing the tag. Git refuses to create a duplicate tag. Fix: push tags or
delete the local tag before re-versioning.

**`exports` breaks subpath imports** — If a consumer was doing `import x from 'pkg/internal'`
and you added an `exports` map without listing that path, it now throws. Only paths explicitly
listed in `exports` are importable.

---

## Project Context

Check AGENTS.md or a local context overlay for:
- Which registry (npmjs.com vs private)
- Whether CI/CD handles publish or it's manual
- Specific peer dependency constraints
- Links to existing published packages in the same scope for naming consistency
