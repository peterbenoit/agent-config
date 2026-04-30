# Open Items

Remaining work from the 2026-04-29 findings review.

---

## Code / Functional

- [ ] **Hook pattern matching** — spacing variants like `git   push` slip through `grep -qF`. Normalize whitespace in the extracted command before matching, or use a stricter approach.
- [ ] **Hook test coverage** — no fixture tests for block/allow cases. Add tests for: `git push`, `git push origin branch`, `git reset --hard`, `git clean -fd`, commands with "git push" in a comment or string, multiple commands in one invocation.
- [ ] **`update.sh` README handling** — `skills/README.md` is overwritten even in safe mode. Apply the same modified-file check used for `SKILL.md` files.

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

- [ ] **Contributor guidance** — a short doc (or section in AGENTS.md) covering: how to review a new skill, the universality test, how to test `init.sh` / `update.sh`, how to communicate breaking changes downstream.
- [ ] **License** — none exists; reuse rights are ambiguous if this toolkit is ever shared.
