# agent-config — Improvements Backlog

Comparison against the hasna/skills repo, filtered for what's actually applicable here.
This is not a port. It's a list of patterns worth stealing, gaps worth filling, and things
worth hardening. Sorted roughly by effort, not by priority.

> **Convention for agents:** Items are markdown checkboxes. Mark `- [x]` immediately when
> an item is fully implemented and verified — not at the end of a session, not when planned.
> Add new items as `- [ ]`. The checkbox state is the source of truth.

---

## Repository Structure and Documentation

- [x] **1. Add CHANGELOG.md**
Track what changed between versions of skills and scripts. Even a flat `## Unreleased` format
is enough. Hasna tracks this at the package level. For a personal toolkit it matters because
projects using `update.sh` have no way to know what changed between their install and now.

- [ ] **2. Add CONTRIBUTING.md**
Even for a solo repo, the discipline of writing contribution rules clarifies the conventions
you've already decided and makes the repo shareable without a verbal handoff.

- [x] **3. Add SECURITY.md**
One page. What to do if you find a problem. Responsible disclosure if you ever share this
publicly. Hasna has a proper one. Doesn't take long and signals intent.

- [x] **4. Add a VERSION file or version field**
No way to know what "version" of agent-config a project was initialized from. Even a plain
`VERSION` file (`0.1.0`) would let `update.sh` report whether a project is behind. Pairs
with CHANGELOG.md.

- [ ] **5. Add a `docs/` folder**
Hasna has `docs/architecture/`, `docs/product/`, `docs/release/`. Even for agent-config,
a `docs/` folder for design decisions ("why is the overlay pattern `.local.md` and not a
directory?") would be useful reference and context for agents working on the toolkit itself.

- [x] **6. Add `.claude/settings.json` in the repo root**
When Claude Code works inside agent-config, it currently has no project-level hook config.
Add `.claude/settings.json` wiring `block-dangerous-git.sh` as a hook for this repo itself.
Eat your own cooking.

---

## Skill Frontmatter and Structure

- [x] **7. Add `category:` field to skill frontmatter**
Skills are undifferentiated. Hasna has 17 categories. Even a small set (Workflow, Code Quality,
Content, Accessibility, Security, Meta) would let scripts filter, group, and report more usefully.
Example:
```yaml
category: "Code Quality"
```

- [x] **8. Add `tags:` field to skill frontmatter**
Freeform tags beyond category. Useful for search scripts and for agents deciding what to load.
Example:
```yaml
tags: [tdd, testing, red-green-refactor, javascript]
```

- [ ] **9. Add `requires:` field for skills that need env vars or tools**
Hasna extracts env vars and system deps by scanning doc files with regex. That's fragile.
Better to declare them explicitly in frontmatter for skills that actually need something:
```yaml
requires:
  env: [OPENAI_API_KEY]
  tools: [jq, ffmpeg]
```
Right now a user installing the `analytics` or `og-images` skill has no way to know what
they need before they try to run it.

- [ ] **10. Add `agents:` field declaring which agent environments each skill works with**
Some skills may be VS Code Copilot-specific, others work in Claude Code, others are universal.
Currently undocumented per-skill.
```yaml
agents: [claude, copilot, cursor, codex]
```

- [ ] **11. Add `triggers:` as a separate frontmatter array instead of embedding in `description:`**
The current approach embeds trigger phrases in the description paragraph. This makes the
description do double duty and makes it impossible for scripts to extract triggers without
parsing prose. A discrete field is more reliable:
```yaml
triggers:
  - "grill me"
  - "poke holes in my plan"
  - "stress-test this"
```

- [ ] **12. Formalize the deferred skill structure**
AGENTS.md mentions 2 deferred skills but they don't appear in the directory listing with any
consistent marker. Hasna handles this by simply not having the directory. Define a convention:
either a `_deferred/` folder with a `SKILL.md` containing `status: deferred`, or a plain
text file in the root listing deferred ideas. Right now there's nowhere to look.

- [ ] **13. Add a per-skill `README.md` alongside `SKILL.md`**
The SKILL.md is the agent-facing instruction file. A separate README.md per skill would be
the human-facing reference: when to use it, what it produces, known limitations, overlay
examples. Right now the SKILL.md has to serve both audiences and makes compromises for both.

- [ ] **14. Add `.env.example` per skill that needs API keys**
Hasna generates `generateEnvExample()` from skill metadata. For skills that require env vars
(any skill that might call an external API), a `.env.example` file documents what's needed
in the form people expect. Even a one-liner is better than nothing.

- [ ] **15. Add skill-level `version:` frontmatter**
No way to know when a skill last changed or what version a project has installed. Even a
simple `version: 1.3` or a date (`updated: 2026-05-01`) would let `update.sh` report
actual drift instead of relying on file hash comparison.

- [ ] **16. Add a custom skill discovery path**
Hasna discovers skills from `~/.hasna/skills/custom/`. agent-config references
`~/.agents/skills/` in update.sh symlinks but never loads custom skills from a user directory.
Define `~/.agents/skills/custom/` as the place for personal non-universal skills that don't
belong in this repo. Update `validate.sh` to ignore that path and document the convention.

---

## validate.sh Improvements

- [x] **17. Validate prompt frontmatter**
`validate.sh` checks skills, hooks, and instructions. It doesn't check `prompts/`. At minimum,
verify each `.prompt.md` has `name:`, `description:`, and `agent:` fields.

- [x] **18. Validate context file structure**
Context files are plain markdown templates. validate.sh doesn't check them. Add a check that
each `.md` in `context/` has at least a heading and is non-empty. Optionally check that
template placeholder comments (`<!-- ... -->`) exist.

- [x] **19. Validate templates for required placeholders**
Templates in `templates/` use HTML comment placeholders. validate.sh doesn't touch them.
Add a check that each template file contains at least one `<!-- ... -->` placeholder (to
catch templates that got fully filled in by mistake and committed as project-specific content).

- [ ] **20. Check minimum trigger phrase count in skill descriptions**
The AGENTS.md convention says descriptions should have 4-6 trigger phrases. validate.sh
doesn't verify this. Add a check that each skill description contains at least 4 quoted
or italicized phrases, or at least 4 instances of something that looks like a trigger phrase.

- [x] **21. Validate `category:` and `tags:` fields if added**
Once frontmatter is extended (items 7-8 above), validate.sh should check that `category:`
is one of the allowed values and that `tags:` is a non-empty list.

- [x] **22. Check global symlink health**
update.sh checks symlink health but validate.sh doesn't. Move (or copy) the symlink check
into validate.sh so a single `./validate.sh` run gives you a complete health picture.
Right now you have to run update.sh from agent-config just to check symlinks, which is odd.

- [ ] **23. Validate `requires:` env vars are documented in the skill body**
If a skill declares `requires: env: [OPENAI_API_KEY]` in frontmatter, validate.sh should
confirm that string appears in the SKILL.md body too, so it's visible to a reader scanning
the doc without parsing frontmatter.

---

## New Scripts

- [x] **24. `list.sh` — list all skills with categories and descriptions**
Right now there's no command to see all skills at a glance with their one-line descriptions.
A `list.sh` could print a formatted table (or JSON with `--json`) of skill name, category,
and the first sentence of the description. Useful for scanning the library and for piping
into other tools.

- [x] **25. `search.sh` — grep-based skill search**
Hasna has a `searchSkills()` function that matches on name, description, and tags.
A `search.sh <query>` that greps skill names and descriptions would be the shell equivalent.
One-liner on top of `list.sh` output, but worth making explicit.
```bash
./search.sh "accessibility"  # → lists skills matching the query
```

- [x] **26. `diff.sh` — compare project installed skills vs source**
Hasna has a `skills diff <name>` command. A `diff.sh` you run from a project root would
compare each installed skill against the agent-config source and report: current, behind,
or locally modified. This is the gap update.sh currently papers over by skipping modified
files silently.

- [ ] **27. `diagnose.sh` — full system health check**
A script combining: symlink check, hook install status per project, outdated skill count,
missing instructions, and missing prompts. The goal is a single command that tells you
the state of your agent tooling without reading three different READMEs.

- [x] **28. `new-skill.sh` — scaffold a new skill from the terminal**
Equivalent to the `new-skill` prompt, but as a shell script that creates the directory
and SKILL.md stub without needing to be inside VS Code. Useful when you're in a terminal
and want to capture a skill idea immediately.
```bash
./new-skill.sh database
# Creates skills/database/SKILL.md with frontmatter stub
```

- [x] **29. `install-hooks.sh` — install hooks into a target project**
init.sh copies skills. It does not install hooks or instructions into a project.
A separate `install-hooks.sh` run from a project root would copy hook scripts into
`.claude/hooks/` and either create or merge `.claude/settings.json`. This is a natural
companion to init.sh and removes a manual step from the setup docs.

- [x] **30. `install-instructions.sh` — copy instructions into a project**
Same gap as hooks. Instructions are always-on rules that load automatically by file pattern.
Projects need to have the `.instructions.md` files present locally for this to work.
Currently they're not copied by init.sh. A dedicated script (or adding this to init.sh
with a `--with-instructions` flag) closes the gap.

---

## init.sh Improvements

- [ ] **31. Add `--select` flag to install only named skills**
Hasna supports `skills pin --category`. A `--select seo,tdd,security` flag on init.sh
would let you wire a subset of skills without manually deleting the rest post-copy.
Useful for projects that don't need the full library.

- [ ] **32. Add `--with-hooks` flag**
Wire hooks in the same init run. Currently you have to read the hooks README and do it
manually. At minimum, ask during init whether to install `block-dangerous-git.sh`.

- [ ] **33. Add `--with-instructions` flag**
Same for instructions. Always-on rules are arguably more important than skills to have
wired correctly from day one.

- [ ] **34. Add `--template` flag to select which AGENTS.md starter to drop**
init.sh always drops `agents-default.md`. But if you're initializing a federal app, you
want `agents-federal-app.md`. The flag could be:
```bash
~/GitHub/agent-config/init.sh --template federal-app
```

- [ ] **35. Detect and warn if target project already has a different version of agent-config**
init.sh skips existing skills/ directories. But it doesn't detect the case where a project
was initialized from a significantly older agent-config and the skills are out of date.
A "last initialized" timestamp in a `.agent-config` dotfile would make this detectable.

---

## update.sh Improvements

- [ ] **36. Update hooks alongside skills**
update.sh updates skills but leaves hooks untouched. If `block-dangerous-git.sh` gets an
important security fix, there's no automated path to update it in projects. Add optional
hook update (with the same "skip if locally modified" logic as skills).

- [ ] **37. Update instructions alongside skills**
Same gap. Instructions change. update.sh should offer to sync them.

- [ ] **38. Report skill version delta explicitly**
Instead of "skill X is modified, skipping", report "skill X installed at version 1.1,
source is 1.3 — run with --force to update or diff with ./diff.sh". Requires version
frontmatter (item 15).

---

## Hook System Improvements

- [x] **39. Add a `log-tool-use.sh` hook (PostToolUse)**
A post-execution hook that appends a one-liner to a local `.agent-session.log` every time
the agent writes a file or runs a bash command. Useful for reviewing what the agent did
in a session without reading the full transcript. Claude Code supports PostToolUse.

- [x] **40. Add a `block-file-writes.sh` hook**
Similar to block-dangerous-git.sh but for file writes. A configurable list of paths
(e.g., `.env`, `*.secret`, `secrets/`) that the agent should never write to. Claude Code's
PreToolUse fires before Write tool calls too.

- [x] **41. Add a `check-test-before-commit.sh` hook**
A hook that runs before `git commit` commands and blocks if the test suite is failing.
Enforces TDD discipline at the hook layer rather than just the skill instruction layer.

- [x] **42. Add `test-block-file-writes.sh` alongside each new hook**
You have `test-block-dangerous-git.sh`. Every new hook should ship with a fixture test.
Make this a convention enforced by validate.sh: every `*.sh` in `hooks/` that isn't
prefixed with `test-` must have a corresponding `test-<name>.sh`.

---

## Prompt Improvements

- [x] **43. Add `new-context.prompt.md`**
Analogous to `new-skill.prompt.md` but for creating new context files. Asks about
the project type, fills in the template structure, and ensures the glossary and key
relationships sections are completed.

- [x] **44. Add `update-skill.prompt.md`**
An on-demand prompt for reviewing an existing skill and proposing updates: checking
that trigger phrases are still accurate, methodology is current, and the scope is
still universal. Different from `new-skill` which creates from scratch.

- [x] **45. Add `diagnose.prompt.md`**
Prompts the agent to run validate.sh, check symlinks, and report the full system state
in a human-readable summary. Sets `agent: ask` mode since it's read-only.

- [x] **46. Validate prompts in validate.sh**
Already noted under validate.sh (item 17), but worth repeating here: prompts are currently
invisible to the validation system. That means a broken prompt file can sit undetected.

---

## Context File Improvements

- [x] **47. Add `drupal.md` context file**
You work on Drupal projects. There's no Drupal context file. A Drupal context template
would cover: hook system, theme layer (Twig), module structure, configuration management,
and common gotchas (render arrays, cache tags, service containers).

- [x] **48. Add `va-gov.md` context file**
You work on VA government properties. A VA/federal-specific context distinct from the
generic `federal-app.md` would cover: VADS, USWDS, 508/WCAG in the VA context, GA4 +
GTM conventions, specific approval workflows, and the CMS stack.

- [x] **49. Add `node-api.md` context file**
A Node.js REST API context with conventions for: route structure, auth middleware,
input validation, error handling, logging, and test patterns.

- [x] **50. Add `npm-package.md` context file**
A context for building and publishing npm packages: package.json conventions, the
`files` field, CJS vs ESM dual publish, semantic versioning, and publish checklist.

- [ ] **51. Add a `context-chooser` skill or prompt**
No current mechanism tells an agent which context file applies to the current project.
A skill or prompt could ask the agent to inspect the project and suggest which context
file to load. Or init.sh could drop a `.agent-context` file naming the relevant context.

---

## Template Improvements

- [x] **52. Add `agents-mcp-server.md` template**
No template for MCP server projects. A starter covering: what tools this server exposes,
transport type (stdio vs SSE), auth approach, and development workflow.

- [x] **53. Add `agents-cli-tool.md` template**
No template for CLI tools. Covers: command structure, argument parsing, stdin/stdout
conventions, error exit codes, and test strategy.

- [x] **54. Add `agents-npm-package.md` template**
A template scoped to npm library development: exports map, dual CJS/ESM, peer deps,
bundlesize constraints, and semver rules.

- [ ] **55. Add skill recommendations to each template**
Hasna's `BASIC_SKILL_NAMES` concept — a curated subset for common use. Each AGENTS.md
template could include a "Recommended skills for this project type" section listing which
skills to install from agent-config. Makes init.sh's `--template` flag (item 34) more valuable.

---

## Agent Integration Improvements

- [ ] **56. Add shell completion for skill names**
Hasna has a `completion` command. A `completion.sh` for agent-config that generates
zsh/bash completions for skill names would make `--select` flags on init.sh and search.sh
tab-completable. Minor quality-of-life, but Hasna thought it was worth doing.

- [x] **57. Add a machine-readable skill registry (`registry.json`)**
A generated JSON file listing all skills with their frontmatter. Built by a `build.sh`
or as a side effect of validate.sh. Useful for: IDE integrations, piping into other scripts,
and for agents that want to inspect the full library without parsing markdown.

- [x] **58. Add `.vscode/tasks.json`**
Wire validate.sh, list.sh, search.sh, and test-scripts.sh as VS Code tasks so they can
be run from the command palette without switching to a terminal. Low effort, high usability
when working on agent-config in VS Code.

- [ ] **59. Track a `.agent-config` dotfile in initialized projects**
When init.sh runs, write a `.agent-config` file to the project root with: source path,
init date, and skill list. This lets update.sh detect projects initialized from this repo,
diagnose.sh report their status, and diff.sh know what to compare against.

- [x] **60. Add a `CLAUDE.md` at the repo root**
AGENTS.md is the general agent manifest. CLAUDE.md is Claude Code-specific and has
distinct loading behavior (it's always loaded in the session context, not just when named).
A root-level CLAUDE.md pointing at AGENTS.md and noting the `.claude/settings.json`
hook configuration would make Claude Code sessions inside agent-config fully configured
without any manual setup step.

---

## Housekeeping

- [x] **61. Remove `.DS_Store` from the repo**
It's in the directory listing. It should be in `.gitignore` and removed from tracking.
```bash
echo ".DS_Store" >> .gitignore
git rm --cached .DS_Store
```

- [x] **62. Audit `skills/.system/` folder**
The listing shows a `skills/.system/` directory with no `SKILL.md`. validate.sh skips it
(no SKILL.md = skipped). What's in there and does it belong? If it's internal scaffolding,
document it. If it's a deferred skill, apply the deferred convention (item 12).

- [ ] **63. Add a `bunfig.toml` or runtime config equivalent if scripts grow**
Hasna's `bunfig.toml` configures the test runner. agent-config uses bash, so no equivalent
is needed now. But if test-scripts.sh grows to cover all scripts, a `test.config.sh`
sourced by each test file would prevent common setup from being duplicated across test files.

---

## Summary by Effort

**Quick wins (under an hour each):**
Items 1, 3, 7, 8, 17, 22, 24, 61, 62

**Medium effort (a focused session each):**
Items 9, 10, 11, 13, 15, 18, 19, 20, 25, 26, 28, 43, 44, 46, 47, 48, 57, 60

**Larger work (a few sessions):**
Items 2, 4, 5, 6, 12, 14, 16, 27, 29, 30, 31-35, 36-38, 39-42, 45, 51, 52-55, 58, 59


---

## Gap Analysis — May 2026

Identified by auditing Pete's actual work domains (VA/federal, Brick City Creative client work,
vanilla JS/CSS frontend, Drupal, npm packages) against what the toolkit currently covers.

### New Skills

- [x] **64. Add `drupal` skill**
Covers Drupal theming and development: Twig templates, preprocess hooks, config sync, render
arrays, cache tags, hook system, drush workflow. Context file exists (`context/drupal.md`) but
there is no agent specialist. Used constantly on VA work.

- [x] **65. Add `debug` skill**
Systematic debugging methodology: reproduce → isolate → hypothesize → verify. Covers DevTools
usage, binary search isolation, reading stack traces, common JS/CSS/network failure patterns.
No current skill for when something is broken.

- [x] **66. Add `npm-publish` skill**
Covers the @peterbenoit package publish lifecycle: semver decisions, CHANGELOG maintenance,
dual ESM/CJS, pre-publish checklist, `npm pack` dry run, registry hygiene, deprecation.
npm-safety covers install time; nothing covers publish time.

- [x] **67. Add `css-architecture` skill**
Custom properties strategy, specificity decisions, responsive patterns, BEM vs utility
tradeoffs, when to use a class vs a property, cascade management. CSS is a major part
of daily work with zero dedicated coverage.

- [x] **68. Add `discovery` skill**
Structures client kickoffs and requirements gathering: right questions to ask, how to scope
a project, what to document before writing a line of code. For Brick City Creative client work.

- [x] **69. Add `handoff` skill**
Covers project handoff to clients: README conventions, deployment runbooks, training notes,
"things that will break" lists, credentials documentation, maintenance guide structure.

### New Prompts

- [x] **70. Add `code-review.prompt.md`**
Structured code review against Pete's standards: no var, no jQuery, no React for simple
problems, accessible, native APIs first, functions small and single-purpose. Avoids having
to re-specify personal standards each session.

- [x] **71. Add `accessibility-audit.prompt.md`**
Full 508/WCAG page audit workflow. Different from invoking the `qa` skill ad-hoc — this
is a structured prompt that produces a prioritized findings report.

- [x] **72. Add `new-context.prompt.md`** *(already in backlog as item 43, re-listed for completeness)*

- [x] **73. Add `update-skill.prompt.md`** *(already in backlog as item 44, re-listed for completeness)*

### New Hooks

- [x] **74. Add `log-tool-use.sh` (PostToolUse)**
Appends a one-liner to `.agent-session.log` every time the agent writes a file or runs a
command. For VA work specifically, being able to produce an audit trail of what the AI
touched in a session is important. Pairs with test file per item 42 convention.

- [x] **75. Add `block-file-writes.sh` (PreToolUse)**
Blocks agent writes to `.env`, `*.secret`, `secrets/`, and other sensitive path patterns.
The git hook blocks commits; this blocks writes before they happen. Pairs with test file.

- [x] **76. Add `check-test-before-commit.sh` (PreToolUse)**
Blocks `git commit` commands if the test suite is failing. Enforces TDD at the hook layer
rather than relying on the `tdd` skill to instill discipline. Pairs with test file.

### New Scripts

- [x] **77. Add `install-hooks.sh`**
Copies hook scripts into a target project and creates or merges `.claude/settings.json`.
init.sh copies skills; hooks require a separate manual step that this closes.

- [x] **78. Add `diff.sh`**
Compares each installed skill in a project against the agent-config source. Reports: current,
behind, or locally modified. Addresses the gap where update.sh silently skips modified files.

### New Context Files

- [x] **79. Add `npm-package.md` context** *(already in backlog as item 50, re-listed for completeness)*
For @peterbenoit package repos: package.json conventions, `files` field, CJS vs ESM,
semver, publish checklist.

- [x] **80. Add `node-api.md` context** *(already in backlog as item 49, re-listed for completeness)*

### New Templates

- [x] **81. Add `agents-drupal.md` template**
Starter AGENTS.md for Drupal projects. Covers: Drupal version, theme layer, module list,
config sync process, deployment workflow, and which skills to install.

- [x] **82. Add `agents-npm-package.md` template**
Starter for @peterbenoit npm package repos: exports map, dual CJS/ESM, peer deps,
bundlesize constraints, semver rules, and publish checklist reference.

### Structural / Discoverability

- [x] **83. Add `registry.json` (machine-readable skill index)**
*(already in backlog as item 57, re-listed for emphasis)*
The AI is too dependent on the user knowing to ask for a specific skill. A registry.json
built by validate.sh or a separate build.sh makes the full library inspectable without
parsing markdown. Foundation for context-chooser and future IDE integrations.

- [ ] **84. Add `context-chooser` skill or prompt**
Inspects a project (package.json, composer.json, file structure, AGENTS.md) and recommends
which context file(s) and skills to load. Closes the discoverability gap where skills exist
but don't get invoked because the user doesn't know to ask.

---

## Global Agent Distribution — May 2026

The goal: one repo (agent-config), latest skills available everywhere agents look for them,
nothing manually copied or stale.

- [ ] **85. Audit and complete the global symlink map**

Current symlinks checked by validate.sh and update.sh:
- `~/.agents/skills` → `agent-config/skills/`
- `~/.claude/skills` → `agent-config/skills/`
- `~/.codex/skills` → `agent-config/skills/`

Missing or unverified:
- `~/.copilot/` — does VS Code Copilot read from here? What path/filename does it expect?
- Claude Desktop — reads from `~/Library/Application Support/Claude/` — are skills wired there?
- Cursor — reads from `~/.cursor/` — not in the symlink map
- Any other agents added in the future

Action: inventory exactly where each agent looks for skills, instructions, and prompts.
Document the full map in README.md. Add every verified path to the symlink check in validate.sh.

- [ ] **86. Add `setup.sh` — one-command global wiring**

Right now the symlinks are not created by any script. They exist because they were set up
manually at some point. There is no documented setup step, no script to run on a new machine,
and no way to verify the full set is correct without running validate.sh and reading its output.

A `setup.sh` that creates (or verifies) all global symlinks would make the system reproducible:

```bash
~/GitHub/agent-config/setup.sh
# Creates:
#   ~/.agents/skills → ~/GitHub/agent-config/skills
#   ~/.claude/skills → ~/GitHub/agent-config/skills
#   ~/.codex/skills  → ~/GitHub/agent-config/skills
#   ~/.copilot/...   → (whatever Copilot reads)
#   + any prompts and instructions each agent loads globally
# Skips symlinks that already point to the right place.
# Reports broken or missing symlinks.
```

Flags: `--dry-run` to preview, `--force` to replace incorrect symlinks.
This is the missing "install agent-config on a new machine" script.

- [ ] **87. Wire prompts globally for agents that support them**

Skills are symlinked globally. Prompts are not. VS Code Copilot reads `.prompt.md` files
from `~/Library/Application Support/Code/User/prompts/`. Claude Code has its own prompt
path. Neither is currently wired.

`setup.sh` (item 86) should also symlink or copy `prompts/` files to wherever each agent
expects them. The goal: `/new-skill`, `/diagnose`, `/code-review`, etc. available in every
agent session without any per-project setup.

- [ ] **88. Wire instructions globally for agents that support them**

VS Code Copilot reads `.instructions.md` from the VS Code user instructions folder. Currently
these require per-project installation via `install-instructions.sh`. There may be a global
path that fires across all workspaces.

Research: does VS Code support a user-level instructions folder (not workspace-level)?
If yes, symlink `instructions/` there in `setup.sh`. If no, this stays per-project only
and `install-instructions.sh` is the right tool.

- [ ] **89. Add `~/.copilot` (or equivalent) to the symlink map**

The existing symlinks cover `~/.claude` and `~/.codex` but not anything Copilot-specific.
Research what path (if any) VS Code Copilot reads for user-level skills or instructions,
then add it to the symlink map and to validate.sh's health check.

- [ ] **90. Document the full distribution matrix in README.md**

No single place currently explains what each agent gets and how. Add a table:

| Asset | Claude Code | Claude Desktop | VS Code Copilot | Codex | Cursor |
|-------|-------------|---------------|-----------------|-------|--------|
| Skills | `~/.claude/skills` symlink | ? | attached manually / `#file` | `~/.codex/skills` symlink | `~/.cursor/` ? |
| Prompts | ? | ? | `~/Library/.../User/prompts/` | ? | ? |
| Instructions | project `.github/instructions/` | n/a | project `.github/instructions/` | ? | ? |
| Hooks | `.claude/settings.json` | n/a | n/a | ? | ? |

Fill in every cell. Where an agent doesn't support a mechanism, note that explicitly so
future investigation starts from a documented gap, not a guess.

---

## Human Notes

- I'd like a way to set goals. I think there's a built-in skill for that? I just don't know how to apply it to projects. Just thoughts.
