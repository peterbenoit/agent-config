# Open Items

Remaining work from the 2026-04-29 findings review.

---

## Code / Functional

- [x] **Hook pattern matching** — whitespace normalized with `tr -s ' '` before pattern matching in `block-dangerous-git.sh`.
- [x] **Hook test coverage** — `hooks/test-block-dangerous-git.sh` added; 38 fixture tests covering blocked patterns, whitespace variants, safe commands, and empty/missing payloads. Two known false positives (pattern in string/comment) documented in test output.
- [x] **`update.sh` README handling** — `skills/README.md` now uses the same modified-file check as skill files: skipped in safe mode if locally changed, overwritten only with `--force`.

---

## Docs / Content

- [ ] **VPAT "always use latest"** — `skills/508/SKILL.md` should tell the agent to verify the current template version from the ITI website rather than assuming it knows the latest.
- [ ] **Root README skill discovery claim** — "Skills are loaded by the agent when the task matches the trigger phrases / You don't configure which skills load" — not true for all agents. Distinguish environments that support native skill loading from those that only read `AGENTS.md`.
- [ ] **Thin skill descriptions** — `git-guardrails` and `tdd` lack explicit "Trigger on phrases like..." examples. Add 4–6 trigger phrases to each.
- [ ] **"This project" wording in universal skills** — `content-strategy`, `design`, `docs`, `performance`, `security`, `social` say "this project" where they mean "the current project". Replace throughout.
- [ ] **Template over-specificity** — mark example-only guardrails as such in: `agents-js-library.md` (zero-dependency claim, no async delivery), `agents-web-app.md` (RLS assumption), `agents-federal-app.md` (`npm audit` before every deploy).
- [ ] **Hook README security note** — add a warning that hook scripts execute inside downstream agent sessions and should be inspected before global install.

---

## Missing

- [x] **Contributor guidance** — added `## Changing the Toolkit` section to AGENTS.md covering skill review, init/update testing, hook modification, and downstream release notes.
- [x] **License** — MIT license added (`LICENSE`).
