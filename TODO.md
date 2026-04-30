# Open Items

Remaining work from the 2026-04-29 findings review.

---

## Code / Functional

- [x] **Hook pattern matching** — whitespace normalized with `tr -s ' '` before pattern matching in `block-dangerous-git.sh`.
- [x] **Hook test coverage** — `hooks/test-block-dangerous-git.sh` added; 38 fixture tests covering blocked patterns, whitespace variants, safe commands, and empty/missing payloads. Two known false positives (pattern in string/comment) documented in test output.
- [x] **`update.sh` README handling** — `skills/README.md` now uses the same modified-file check as skill files: skipped in safe mode if locally changed, overwritten only with `--force`.

---

## Docs / Content

- [x] **VPAT "always use latest"** — `skills/508/SKILL.md` now tells the agent to retrieve the current template from the ITI website (itic.org) before starting, rather than assuming it knows the latest version.
- [x] **Root README skill discovery claim** — "Using Skills" section now distinguishes Claude Code (automatic, description-based) from GitHub Copilot/Cursor/VS Code (no native loader; must reference explicitly or via instructions file).
- [x] **Thin skill descriptions** — `git-guardrails` and `tdd` now have 4–6 explicit trigger phrases each in their frontmatter descriptions.
- [x] **"This project" wording in universal skills** — replaced with "the current project" throughout `content-strategy`, `design`, `docs`, `performance`, `security`, `social`.
- [x] **Template over-specificity** — moved zero-dependency and no-async-delivery guardrails to `<!-- Example guardrail -->` comments in `agents-js-library.md`; same for RLS in `agents-web-app.md` and `npm audit` in `agents-federal-app.md`. Universal guardrails kept as-is.
- [x] **Hook README security note** — added warning before the global install block that hook scripts execute in every agent session and should be inspected before install.

---

## Missing

- [x] **Contributor guidance** — added `## Changing the Toolkit` section to AGENTS.md covering skill review, init/update testing, hook modification, and downstream release notes.
- [x] **License** — MIT license added (`LICENSE`).
