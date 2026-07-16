# Agent Toolkit Roadmap (Codex + Claude + Copilot + Gemini)

This roadmap is optimized for impact first: improve cross-agent reliability, reduce maintenance drag,
and make onboarding repeatable.

---

## Scoring model

- **Impact (1–5):** expected gain in reliability/usability/time saved.
- **Effort (1–5):** implementation cost (higher = harder).
- **Priority Score:** `Impact / Effort`.

---

## Ranked roadmap

| Rank | Initiative | Impact | Effort | Priority | Why now |
|------|------------|--------|--------|----------|---------|
| 1 | Finish backlog #13 and #14 (per-skill README + `.env.example`) | 5 | 2 | 2.50 | Removes ambiguity quickly and improves onboarding for every environment. |
| 2 | Add root-level cross-agent compatibility matrix (`AGENT-COMPATIBILITY.md`) | 5 | 2 | 2.50 | Directly supports your Codex/Gemini adoption goal. |
| 3 | Add script behavior tests (fixture-based for init/update/install scripts) | 5 | 3 | 1.67 | Protects against regressions as scripts evolve. |
| 4 | Introduce quarterly pruning workflow (`keep / merge / deprecate / defer`) | 4 | 3 | 1.33 | Prevents skill sprawl and trigger overlap. |
| 5 | Tighten trigger quality gates in `validate.sh` (warn → fail over time) | 4 | 3 | 1.33 | Improves auto-loading precision in native skill environments. |
| 6 | Add release discipline checklists (`CHANGELOG` + migration notes per breaking change) | 3 | 2 | 1.50 | Helps downstream projects consume updates safely. |

---

## 30/60/90 plan

## Days 0–30 (Quick wins)

1. Complete open backlog items:
   - #13 per-skill `README.md`
   - #14 `.env.example` where applicable
2. Create `AGENT-COMPATIBILITY.md` in repo root with:
   - asset type (skills/hooks/instructions/prompts/context/templates)
   - native support by environment (Claude/Codex/Copilot/Gemini/Cursor)
   - install path and caveats
3. Add a lightweight PR template section requiring:
   - “cross-agent impact” note
   - “backward compatibility” note

## Days 31–60 (Stability)

1. Add fixture tests for shell scripts:
   - `init.sh --dry-run`
   - `update.sh --dry-run`
   - `install-hooks.sh`
   - `install-instructions.sh`
2. Add CI job to run:
   - `./validate.sh`
   - script behavior tests
3. Define deprecation metadata convention for skills (if needed):
   - `status: active|deprecated|deferred`
   - deprecation message + replacement skill

## Days 61–90 (Optimization)

1. Run first pruning cycle:
   - identify overlaps
   - merge narrow/duplicative skills
   - archive/defer low-value skills
2. Tighten validation policy:
   - enforce trigger quality minimum for changed skills
3. Publish first “toolkit release notes” update for downstream repos.

---

## Removal and merge heuristic (use quarterly)

For each skill, score 1–5:

- **Usage frequency** (real usage, not aspirational)
- **Distinctiveness** (does it do something unique?)
- **Cross-agent portability** (works beyond one vendor)
- **Maintenance burden** (cost to keep current)

Decision matrix:

- **Keep:** high usage + high distinctiveness
- **Merge:** low distinctiveness + overlap with another skill
- **Deprecate:** low usage + high maintenance
- **Defer:** useful idea, but not yet stable/reusable

---

## Root-level compatibility matrix template (starter)

Create this as `AGENT-COMPATIBILITY.md` in the repo root:

```md
# Agent Compatibility Matrix

| Asset | Claude Code | Codex | Copilot (VS Code) | Gemini CLI/IDE | Cursor | Notes |
|---|---|---|---|---|---|---|
| skills/ | Native or project-linked | Project/global reference | Manual attach/reference | Manual attach/reference | Rules/reference | Document install path per tool |
| hooks/ | Native (Claude hooks) | Limited/non-native | Non-native | Depends on host | Non-native | Clarify fallback guardrails |
| instructions/ | Project docs only | Project docs only | Native via instructions dirs | Depends on IDE | Rules | Keep universal + narrow scope |
| prompts/ | Non-native | Non-native | Native slash prompts | Depends on IDE | Non-native | Keep reusable and mode-safe |
| context/ | Manual reference | Manual reference | Manual reference | Manual reference | Manual reference | Orientation only |
| templates/ | Copy/fill | Copy/fill | Copy/fill | Copy/fill | Copy/fill | AGENTS.md bootstrapping |
```

---

## Definition of done for this roadmap

- Open backlog items #13 and #14 are complete.
- Root-level compatibility matrix exists and is referenced from `README.md`.
- Script behavior tests run in CI.
- First pruning cycle completed with explicit keep/merge/deprecate decisions.
