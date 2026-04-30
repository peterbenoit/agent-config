# Action Items — CODEX + Gemini Evaluation

Consolidated from `CODEX_findings.md` and `Gemini_evaluation_report.md`.
Verified against current repo state on 2026-04-30.

Statuses: `[ ]` not started · `[~]` partial · `[x]` done · `[-]` won't fix / intentional

---

## Priority 1 — Confirmed Bugs (Wrong Behavior Today)

- [x] **Fix overlay path in all six AGENTS templates**
  All templates say `./skills/<name>/SKILL.md` for the overlay. Correct path is `./skills/<name>.local.md`.
  Affects: `templates/agents-default.md`, `agents-static-site.md`, `agents-web-app.md`, `agents-js-library.md`, `agents-bigcommerce.md`, `agents-federal-app.md`.
  `init.sh` and `skills/README.md` already use the correct path — this is pure template drift.

- [x] **Fix `hooks/README.md` "Writing a New Hook" section**
  Says context arrives via `$BASH_COMMAND` environment variable. Actual contract is stdin JSON.
  This directly contradicts the hook script and the AGENTS.md hook spec note.

- [x] **Fix `hooks/README.md` blocked-command list**
  Prose list omits `git branch -d` and `git restore --staged`, both of which `block-dangerous-git.sh` actually blocks.

- [ ] **Fix `update.sh --force` warning messaging**
  Warning says "Local skill overlays will be overwritten." Under `.local.md` convention, overlays are never touched by `update.sh`. What `--force` actually overwrites is modified copied base `SKILL.md` files. Rewrite to distinguish the two.

- [ ] **Fix `update.sh` skip counter for `skills/README.md`**
  When `skills/README.md` differs and `--force` is off, the script prints a skip line but does not increment `count_skipped` and does not add it to `skipped_names`. Summary underreports skips.

- [ ] **Fix `validate.sh` heredoc check scope**
  Currently only checks section header presence and one placeholder line — reports pass even when overlay path in `init.sh` differs from templates. Either do a full heredoc-vs-template diff or explicitly document that the check is header-only (so it stops implying full sync).

---

## Priority 2 — Stale Documentation (Misleading But Not Broken)

- [ ] **Fix `README.md` `--force` warning**
  Root README says `--force` "will clobber local overlays." Under `.local.md` convention this is wrong. Rewrite to name the actual risk: edited base `SKILL.md` files and `skills/README.md`.

- [ ] **Add `jq` as a listed dependency in `hooks/README.md`**
  Install instructions don't mention `jq`. The git-guardrails skill covers it, but hooks are copied independently. Dependency should live where the hook is documented.

- [ ] **Add `hooks/README.md` note on parse-failure behavior**
  If hook can't parse stdin, it exits `0` (allow). This is an intentional availability tradeoff but undocumented. A security-conscious user needs to know the threat model.

- [ ] **Add `hooks/README.md` note on known false positives**
  Comments, strings, and echoed docs containing blocked phrases will trigger blocks. Documented in test output but absent from the user-facing hook README.

- [ ] **Fix `writing.instructions.md` scope statement**
  `applyTo: '**/*.md'` — body says it covers "commit messages" and "comments in code files." Those are out of scope for the `applyTo` pattern. Either narrow the prose or broaden the pattern.

- [ ] **Update `init.sh` "Next steps" output**
  Step 2 says "Add project-specific skill overlays to skills/ as needed." Now that the repo ships context templates, prompts, instructions, and hooks, next steps should either stay skill-focused (and say so explicitly) or enumerate the other optional assets.

---

## Priority 3 — Validation Gaps (No Enforcement)

- [ ] **Add `validate.sh` check: `instructions/*.instructions.md` frontmatter**
  Verify `name`, `description`, and `applyTo` fields exist in each instruction file.

- [ ] **Add `validate.sh` check: `prompts/*.prompt.md` frontmatter**
  Verify `name`, `description`, and at minimum `agent` or `mode` fields exist.

- [ ] **Add `validate.sh` coverage check: `prompts/README.md`**
  Every `.prompt.md` file should appear in `prompts/README.md`. Same pattern as the existing skills check.

- [ ] **Add `validate.sh` coverage check: `instructions/README.md`**
  Every `.instructions.md` file should appear in `instructions/README.md`.

- [ ] **Add `validate.sh` coverage check: `context/README.md`**
  Every `context/*.md` file should appear in `context/README.md`.

- [ ] **Add `validate.sh` coverage check: `templates/README.md`**
  Every `templates/agents-*.md` file should appear in `templates/README.md`.

---

## Priority 4 — Hook Test Gaps

- [ ] **Promote known false-positive cases to asserted test fixtures in `test-block-dangerous-git.sh`**
  Currently the test prints notes for `echo 'git push ...'` and `# git push comment` cases but does not run them as expected-pass cases. They should be explicit fixtures so regressions are caught.

- [ ] **Decide on fallback parser safety**
  Without `jq`, the `grep`/`sed` fallback mishandles escaped quotes. Options: (a) make `jq` a hard dependency and fail closed on missing `jq`, (b) document the limitation explicitly and accept the tradeoff, (c) improve the fallback. Currently the risk is undocumented.

---

## Priority 5 — Architecture / Distribution Gaps

- [ ] **Add tool-installation matrix to README or a new `INSTALL.md`**
  No single place says where each asset type should land per agent environment (Claude Code, VS Code/Copilot, Cursor, AGENTS.md-only). Without this, users see the assets but can't reliably wire them.
  Examples: where hooks go for Claude Code, where `.instructions.md` goes for VS Code vs Cursor vs Claude Code.

- [ ] **Add AGENTS.md conventions for `prompts/` and `instructions/`**
  AGENTS.md documents skill, hook, template, and context conventions but has no "What Not to Do" rules for prompts or instructions. Needed: reusability rule (no hardcoded project URLs), `applyTo` conservatism, ask-only `agent` mode awareness.

- [ ] **Decide on and document evaluation report convention**
  `CODEX_findings.md` and `Gemini_evaluation_report.md` live at the repo root with no documented convention. Either: define a `reports/` directory with a naming convention and retention policy, or note they are temporary artifacts and move/remove them after action items are resolved.

---

## Priority 6 — Lower-Impact Improvements

- [ ] **Test fixtures for `init.sh`, `update.sh`, `validate.sh`**
  No test infrastructure exists for the setup/update/validation scripts. Useful cases: blank project init, existing AGENTS.md, copied vs symlinked skills, `.local.md` overlays, force mode, dry-run output. High risk, low coverage.

- [ ] **Label personal-style rules in `prompts/pre-publish.prompt.md` and `writing.instructions.md`**
  "No em-dashes" and personal contact-info checks are valid preferences but not universal engineering standards. If this repo is shared as a general toolkit, mark them as project-profile defaults or move to an overlay layer.

- [ ] **Review `pre-publish` robots meta requirement**
  Prompt flags missing `<meta name="robots" content="index, follow">` as a failure. Omitting this tag is valid — index/follow is the default. The check produces false failures for valid pages.

- [ ] **Add a routing guide: skill vs prompt vs instruction**
  README explains each asset type separately but provides no decision matrix. As the toolkit grows, new additions risk landing in the wrong layer. A short "When to use which" section prevents drift.

---

## Won't Fix / Intentional

- [-] **`pre-publish` prompt platform assumptions (Twitter/X, LinkedIn, personal blog)**
  These are intentional personal-toolkit defaults, not bugs. Acceptable as-is for single-author use.

- [-] **AGENTS templates with assertive project-type rules**
  Strong example rules in templates are features, not bugs — templates are meant to be edited. They should remain clearly labeled as examples.

- [-] **Gemini "distribution incompleteness" — no `--with-instructions` flag**
  Expanding `init.sh` to distribute prompts and instructions is a valid roadmap item but introduces scope creep. Evaluate separately if multi-project distribution becomes a real need.
