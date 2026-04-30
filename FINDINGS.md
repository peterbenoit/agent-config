# agent-config Findings

Date: 2026-04-29

Scope: repo structure, root documentation, skill metadata, templates, context files, hook scripts,
and init/update behavior. This is a findings document only; no fixes are included here.

---

## What's Missing

### Automated validation

There is no test or lint entry point for the toolkit itself. A meta-repo like this would benefit
from a small validation command that checks:

- every active skill has valid YAML frontmatter
- every `skills/<name>/SKILL.md` frontmatter `name` matches `<name>`
- every skill description is present and includes enough trigger language
- `skills/README.md` and root `README.md` list the same active skills
- `init.sh`'s heredoc still matches `templates/agents-default.md`
- hooks are executable
- templates do not contain stale project-specific content

Right now these conventions are documented but not enforced, so drift has already appeared.

### A release/update process for this repo

The repo has `init.sh` and `update.sh` for downstream projects, but no documented workflow for
changing the source toolkit itself. Missing pieces:

- how to review a new or modified skill before shipping it
- how to decide when a skill is universal enough
- how to test `init.sh` and `update.sh`
- how to communicate breaking changes to downstream project overlays
- whether copied downstream skills should track a version, checksum, or source commit

### A machine-readable skill index

Skill discovery currently depends on reading directory contents and README tables. There is no
manifest that lists active, deferred, and in-progress skills in one canonical place. That causes
count drift and duplicated tables.

A manifest could also record skill status, owner, last reviewed date, and whether the skill is
safe to copy into projects.

### Hook test coverage

`hooks/block-dangerous-git.sh` is security/safety critical, but there are no fixture tests for
commands that should be blocked or allowed. At minimum, tests should cover:

- `git push`, `git push origin branch`
- `git reset --hard`, `git clean -fd`
- harmless commands that include words like "git push" in comments or strings
- spacing/quoting variants
- multiple commands in one shell invocation
- commands passed via the actual hook input mechanism

### A clear overlay model

The docs say project overlays can live at `./skills/<name>/SKILL.md`, but the copy-based setup
also places the universal skill at exactly that path. There is no separate path for "universal
base" vs. "project overlay", no merge format, and no documented precedence mechanism that an
agent can follow reliably.

This is probably the biggest conceptual gap in the repo. The overlay idea is useful, but the
current file layout does not actually represent two layers.

### Context template coverage

There are context templates for static sites, JS libraries, web apps, and BigCommerce, but not
for federal projects. There is a federal AGENTS template and a 508 skill, so a matching
`context/federal-app.md` would make the system more consistent.

### Contributor guidance

There is no `CONTRIBUTING.md`, review checklist, or short "how to change this repo safely" doc.
AGENTS.md has good instructions for agents, but humans changing the toolkit would benefit from
a compact checklist too.

---

## What Needs Improvement

### README skill counts and tables are drifting

The root `README.md` says the repo has "18 SKILL.md instruction sets + 2 in-progress". The repo
currently has 19 active `SKILL.md` files and 2 README-only placeholders.

The root "Using Skills" table omits `bigcommerce`, even though `skills/bigcommerce/SKILL.md`
exists and `skills/README.md` lists it.

`skills/README.md` also has two active-skill tables back-to-back with overlapping information.
That makes it easy for one table to get updated and the other to go stale.

### `init.sh` default template has drifted from `templates/agents-default.md`

`templates/README.md` says the `init.sh` heredoc matches `templates/agents-default.md`.
It does not. The differences are small but meaningful: the template has more specific
Architecture and What Not to Do placeholder text than the heredoc in `init.sh`.

This should be validated automatically if the heredoc remains duplicated.

### Several skills describe "this project" even though they are universal

Examples include `content-strategy`, `design`, `docs`, `performance`, `security`, and `social`.
That wording is not fatal, but it weakens the universal-skill framing. The skills often mean
"the project currently being worked on", but the phrase can read as if the skill itself is
specific to agent-config or to one downstream project.

Using "the current project" or "the target project" would be clearer.

### Some skill descriptions are less load-bearing than the repo standard asks for

The repo says frontmatter descriptions should include 4-6 trigger phrases and distinguish when
to use the skill. Most do. A few are thinner:

- `git-guardrails` has no explicit "Trigger on phrases like..." list.
- `tdd` is concise and says it applies to any JS/TS codebase, which may be narrower than the
actual TDD methodology.
- `new-project-page`, `new-blog-post`, and `og-images` are useful but lean toward one static-site
publishing model. They rely heavily on AGENTS.md to fill in missing project-specific details.

### The hook documentation is too confident about environment mechanics

`hooks/README.md` says hook scripts receive the command via `$BASH_COMMAND`, `$CLAUDE_PROJECT_DIR`,
and others. That needs to be verified against the actual agent environment and documented with
the real input contract. A safety hook should be explicit about whether it reads stdin JSON,
environment variables, argv, or shell state.

### The update workflow treats `skills/README.md` differently from skill files

`update.sh` protects modified `SKILL.md` files in safe mode, but it updates `skills/README.md`
whenever it differs. If a downstream project edits its copied `skills/README.md`, safe mode
will still overwrite it.

The script's user-facing promise is "updates skills whose files haven't been locally modified"
and "skips skills with local changes." The README file is not handled with the same caution.

### Hooks are documented in two places

`hooks/README.md` and `skills/git-guardrails/SKILL.md` both include the hook script content and
installation instructions. That duplication makes the hook easy to update in one place and miss
in the other.

The skill should probably point to the canonical script in `hooks/` instead of embedding a copy.

### Template assumptions are sometimes too specific

Some templates contain guardrails that may not be universal for the project type:

- `templates/agents-js-library.md` says "this is a zero-dependency library".
- It also says never make delivery behavior async if currently synchronous.
- `templates/agents-web-app.md` assumes RLS or equivalent access control.
- `templates/agents-federal-app.md` suggests `npm audit` before every deployment.

These are good examples, but in a template they may be mistaken for defaults. They should be
clearly marked as examples to keep or delete.

---

## What Is Wrong

### The overlay path is contradictory

Multiple docs say to create a project-specific overlay at `./skills/<name>/SKILL.md`. But when
skills are copied into a project, that path is already occupied by the universal skill. Editing
that file creates a fork, not an overlay.

This also explains why `update.sh --force` warns that it overwrites local overlays: the system
has no separate overlay layer, so updating and overlaying are the same file operation.

### `block-dangerous-git.sh` likely does not inspect the command it is supposed to block

The script sets:

```bash
COMMAND="$BASH_COMMAND"
```

Inside a standalone shell script, `BASH_COMMAND` is shell execution state for the script itself,
not reliably the user's requested Bash command. Unless the hook runner explicitly exports the
target command into `BASH_COMMAND` before invoking the script, this hook will not evaluate the
intended command.

That makes the current guardrail potentially non-functional.

### Hook docs and hook implementation disagree

`skills/git-guardrails/SKILL.md` says blocked by default includes `restore --staged` in bulk.
The actual script in `hooks/block-dangerous-git.sh` does not include any `git restore --staged`
pattern.

The skill and script also duplicate the blocked list, increasing the chance of further drift.

### The hook pattern matching is too loose and too narrow at the same time

The script uses simple `grep -q "$pattern"` checks. Problems:

- It can match text that is not an executed command.
- It misses spacing variants like `git   push`.
- It misses command construction through aliases or shell functions.
- It does not parse command segments.
- It does not understand quoting.
- It may block safe text and miss unsafe shell syntax.

For a safety hook, this needs a stricter command-input contract and a better matching strategy.

### BigCommerce API pagination guidance appears inaccurate

`skills/bigcommerce/SKILL.md` says all v3 list endpoints use cursor-based pagination with an
`after` cursor. BigCommerce v3 APIs commonly use page/limit pagination in many endpoints, and
cursor pagination is not universal across all v3 list endpoints.

That wording could cause agents to implement pagination incorrectly.

### "Always use latest" guidance conflicts with agent reproducibility

`skills/508/SKILL.md` says to always use the latest VPAT version from the ITI website. That may
be the right practical advice, but it requires current external verification. A skill file that
agents read offline should tell the agent to verify the current template/version from the
official source before preparing a VPAT.

### Root docs say skills are loaded automatically by agents

The root README says "Skills are loaded by the agent when the task matches the trigger phrases"
and "You don't configure which skills load." That may be true in some agent environments, but
this repo is meant for Claude Code, GitHub Copilot, Cursor, and other agents. Not all of those
have a native skill loader.

The docs should distinguish "agents that support skill discovery" from "agents that only read
AGENTS.md instructions."

---

## Other Observations

### There is a hidden duplication problem

The same concepts appear in several places:

- active skill list: root README, skills README, filesystem
- default AGENTS template: `templates/agents-default.md`, heredoc inside `init.sh`
- hook install instructions: hook README, hook script comments, git-guardrails skill
- overlay behavior: root README, skills README, templates, init script, update script

This repo is small enough that duplication is manageable today, but the failure mode is already
visible: counts, default template text, and hook blocked lists have drifted.

### Skills vary a lot in depth

Some skills are substantial operating manuals (`bigcommerce`, `security`, `508`, `docs`).
Others are short behavioral prompts (`grill-me`, `zoom-out`). Both formats can be valid, but
the repo does not say when a skill should be a compact prompt vs. a full methodology.

That makes future skill additions harder to judge.

### Some skills may overlap in ways that need routing guidance

Known overlaps:

- `qa` vs. `508`
- `docs` vs. `voice` vs. deferred `techwriter`
- `content-strategy` vs. `new-blog-post` vs. `new-project-page`
- `design` vs. `qa` for visual review
- `security` vs. `git-guardrails` for safety rules

Some descriptions include distinctions, but a short routing matrix in `skills/README.md` would
help agents choose the right one.

### The in-progress skill story is inconsistent

The root README says `refactor` and `techwriter` are in progress. `skills/README.md` says both
are deferred placeholders. Those are not the same state.

Pick one vocabulary: active, in progress, deferred, retired. Then use it consistently.

### The docs assume one local filesystem path

Many examples use `~/GitHub/agent-config/...`. That is fine for a personal toolkit, but if this
repo is meant to be portable or shared, examples should either use `$AGENT_CONFIG_DIR` or explain
that paths are examples to replace.

### There is no security note for copied hooks

Hook scripts execute inside downstream agent sessions. The docs should explicitly say to inspect
hook scripts before installing them globally, because global hooks affect every project.

### The repo has no license

If this toolkit is ever shared beyond personal use, a license should be added. Without one,
reuse rights are ambiguous.

---

## Suggested Priority

1. Fix the overlay model, because it affects every downstream project and the update script.
2. Verify and repair the hook input contract, because the safety hook may not work.
3. Remove source-of-truth duplication: skill index, default template, hook blocked list.
4. Add a validation script so future drift is caught immediately.
5. Tighten skill descriptions and routing guidance.
6. Recheck factual platform guidance in BigCommerce, 508/VPAT, and any other externally changing
   domains.
