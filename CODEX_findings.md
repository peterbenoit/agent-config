# agent-config Findings — Second Pass

Date: 2026-04-30

Scope: fresh review of the expanded repo, including skills, prompts, instructions, hooks,
context templates, AGENTS templates, `init.sh`, `update.sh`, `validate.sh`, and current docs.
This file documents findings only. No fixes are included.

Validation observed:

- `./validate.sh` passes.
- `./hooks/test-block-dangerous-git.sh` passes.
- A full diff between `init.sh`'s AGENTS heredoc and `templates/agents-default.md` still fails.

---

## What's Missing

### Validation for new asset types

`validate.sh` now covers skills, README skill coverage, hook executability, and a partial
`init.sh` heredoc check. It does not validate the newer directories:

- `prompts/*.prompt.md`
- `instructions/*.instructions.md`
- `context/*.md`
- `templates/agents-*.md`

That leaves large parts of the toolkit outside the repo's safety checks. The repo now has
4 prompt files, 3 instruction files, 5 context templates, and 6 AGENTS templates. Only skills
and hooks get meaningful automated coverage.

### README coverage checks for prompts, instructions, context, and templates

The prompt, instruction, context, and template READMEs are hand-maintained. There is no check
that:

- every `prompts/*.prompt.md` file appears in `prompts/README.md`
- every `instructions/*.instructions.md` file appears in `instructions/README.md`
- every context template appears in `context/README.md`
- every AGENTS template appears in `templates/README.md`

This is the same drift problem the skills validator tries to prevent, but only for one directory.

### Exact heredoc/template sync

`validate.sh` claims to check `init.sh` heredoc sync with `templates/agents-default.md`, but it
only checks section headers and one Architecture placeholder line. It does not compare the full
template body.

As of this pass, `validate.sh` reports success even though `init.sh` and
`templates/agents-default.md` differ in the Skills overlay section.

### Distribution path for prompts and instructions

The README now describes `prompts/` and `instructions/` as first-class toolkit assets, but
`init.sh` and `update.sh` only distribute skills and a starter `AGENTS.md`.

There is no supported way to install or update:

- VS Code `.prompt.md` commands
- `.instructions.md` files
- context templates
- hook scripts
- project-type AGENTS templates

That makes the repo's structure broader than its wiring scripts.

### Tool-specific installation mapping

The repo spans Claude Code, VS Code/Copilot, Cursor, hooks, prompts, and instructions, but there
is no matrix that says where each asset type should be installed for each agent environment.

Needed mapping examples:

- Claude Code: where hooks live, whether prompts/instructions are usable
- VS Code/Copilot: where `.prompt.md` and `.instructions.md` files should go
- Cursor: whether `.instructions.md` maps to Cursor rules or needs conversion
- Generic AGENTS.md-only agents: which assets are ignored unless copied into instructions

Without that, users can see the assets but not reliably wire them into real projects.

### Tests for `init.sh`, `update.sh`, and `validate.sh`

There are hook fixture tests, but no test fixtures for the setup/update/validation scripts.
These scripts carry the most downstream risk because they copy or overwrite files in other
projects.

Useful fixtures would cover:

- blank project init
- project with existing `AGENTS.md`
- project with copied skills
- project with `.local.md` overlays
- modified copied `SKILL.md` files
- modified downstream `skills/README.md`
- symlinked `skills/`
- dry-run output
- force mode behavior

### Prompt and instruction frontmatter schema enforcement

`prompts/README.md` documents frontmatter fields like `name`, `description`,
`argument-hint`, `agent`, and `tools`. `instructions/README.md` documents `name`,
`description`, and `applyTo`.

Those schemas are not enforced. A prompt or instruction file can be malformed and
`./validate.sh` will still pass.

### A canonical asset manifest

The repo still relies on multiple READMEs and directory scans as source-of-truth lists. A small
manifest could make active/deferred assets explicit across skills, prompts, instructions,
hooks, templates, and context files.

The repo now has enough asset types that README tables alone are becoming brittle.

---

## What Needs Improvement

### Overlay documentation is split between old and new conventions

The root README and `skills/README.md` now define the corrected overlay path:

```text
./skills/<name>.local.md
```

But every AGENTS template still uses the old contradictory path:

```text
./skills/<name>/SKILL.md
```

Affected files:

- `templates/agents-default.md`
- `templates/agents-static-site.md`
- `templates/agents-js-library.md`
- `templates/agents-web-app.md`
- `templates/agents-bigcommerce.md`
- `templates/agents-federal-app.md`

This is the highest-impact documentation drift because templates are copied directly into
downstream projects.

### `update.sh` force-mode warnings are stale

The new overlay model says `.local.md` overlays are separate files and are never overwritten by
`update.sh`. But `README.md`, `AGENTS.md`, and `update.sh` still warn that `--force` will
clobber or overwrite local overlays.

That warning now appears inaccurate for `.local.md` overlays. What `--force` actually overwrites
is modified copied base files such as `skills/<name>/SKILL.md` and possibly `skills/README.md`.

The warning should distinguish:

- `.local.md` overlays: not touched
- edited universal base files: overwritten in force mode
- copied README: overwritten in force mode

### `validate.sh` gives a false sense of sync

The validator says all checks pass while a direct diff between the default template and the
`init.sh` heredoc shows a real mismatch. This is more dangerous than having no check because it
suggests the invariant is enforced when it is not.

The check should either compare the full heredoc to the template or clearly say it only checks
section presence.

### Hook documentation still contradicts the hook implementation

The top of `hooks/block-dangerous-git.sh` correctly documents stdin JSON and `jq`. Later,
`hooks/README.md` still says a hook receives context via environment variables such as
`$BASH_COMMAND`.

That old paragraph conflicts with the implementation and with AGENTS.md's current statement
that the hook input contract is stdin JSON.

### The hook's `jq` dependency needs installation guidance in hook docs

`hooks/block-dangerous-git.sh` requires `jq` for reliable parsing and has a fallback. The
`git-guardrails` skill tells the user to install `jq` with Homebrew if missing. `hooks/README.md`
does not list `jq` as a dependency in the install instructions.

Because hooks are copied into other projects, dependency requirements should be stated where the
hook is documented, not only in the skill.

### Hook tests document false positives but do not assert them

`hooks/test-block-dangerous-git.sh` prints notes for known false positives:

- `echo 'git push would be bad'`
- `# git push comment`

But it does not run those cases as expected failures. That makes the limitation visible to a
human reader, but not tracked as executable behavior.

If those limitations are accepted, they should be explicit fixture cases. If they are not
accepted, they should be failing tests that drive a parser improvement.

### README wiring sections lag behind new directories

The root README's "Wiring a New Project" section still focuses almost entirely on skills.
Given the repo now includes prompts and instructions, it should explain whether those assets
are:

- intended to be copied manually
- intentionally source-only
- supported by future script flags
- unsupported outside VS Code

Right now the top-level structure advertises them, but setup docs do not help users adopt them.

### `init.sh` next steps still mention only skill overlays

After init, the script says:

```text
2. Add project-specific skill overlays to skills/ as needed
```

That is accurate but incomplete now that the repo also ships context templates, prompts,
instructions, and hooks. The next steps should either remain explicitly skill-only or mention
the other optional assets.

### New asset directories need "What Not To Do" rules

AGENTS.md has conventions for skills, hooks, templates, and context files. It does not yet define
maintenance conventions for:

- `prompts/`
- `instructions/`

Those directories have local READMEs, but the top-level agent instructions do not say what not
to do when changing them. Examples:

- prompts should stay reusable and should not hardcode one site's URLs
- instructions should be ambient and narrow enough not to over-trigger
- instruction `applyTo` patterns should be conservative
- prompts should not silently edit files if their `agent` mode is intended to be ask-only

### The Gemini report is not integrated into the repo model

`Gemini_evaluation_report.md` exists at the root. It reads like an external review artifact,
not reusable toolkit content. There is no docs section explaining whether evaluation reports are
kept, how they should be named, or whether they are temporary review notes.

If reports belong in the repo, they need a convention. If not, they should stay out of the
source toolkit.

---

## What Is Wrong

### Default template and init output disagree

`templates/README.md` says `templates/agents-default.md` matches the `init.sh` heredoc. It does
not.

The direct diff shows the template still says:

```text
./skills/<name>/SKILL.md
```

while `init.sh` now says:

```text
./skills/<name>.local.md
```

That means a user who copies `templates/agents-default.md` manually gets different instructions
from a user who runs `init.sh`.

### All AGENTS templates teach the old overlay path

The corrected overlay convention is `.local.md`, but all six templates still tell agents or
users to create overlays at the universal skill path. This reintroduces the original overlay
bug into every newly templated project.

This is not just stale wording. It changes downstream behavior and can cause users to edit copied
base skill files that `update.sh` may overwrite later.

### `validate.sh` passes despite the overlay-template drift

The validator reports "All checks passed" even with the stale overlay path in templates. This
means the current validation suite does not catch one of the repo's most important invariants:
the documented overlay convention must be consistent everywhere it is emitted or copied.

### `update.sh` skip summary omits skipped `skills/README.md`

When `skills/README.md` differs and `--force` is not used, `update.sh` prints:

```text
~ skills/README.md (local changes — skipped)
```

But it does not increment `count_skipped` and does not add that file to `skipped_names`. The
summary can therefore underreport skipped files, and the diff instructions only cover skipped
skills, not the skipped README.

### `update.sh --force` messaging says overlays are overwritten

With the `.local.md` overlay convention, the message:

```text
--force is set. Local skill overlays will be overwritten.
```

is wrong or at least misleading. `.local.md` overlays are not copied from source and are not
targeted by the script.

### `README.md` still says `--force` will clobber local overlays

The root README says `--force` will overwrite all skills including modified ones and "will
clobber local overlays." Under the new overlay convention, that is stale. It may scare users
away from `--force` for the wrong reason while failing to name the real risk: edited base files.

### `hooks/README.md` blocked list omits `git branch -d` and `git restore --staged`

The actual hook blocks both:

- `git branch -d`
- `git restore --staged`

The hook README's prose list omits them. The table says the script blocks destructive git
commands generally, but the detailed list is out of sync with the canonical script.

### The hook fallback JSON parser is unsafe for escaped quotes

Without `jq`, the hook falls back to a grep/sed extraction of the first `"command"` string. That
fallback does not handle JSON escaping correctly. A command containing escaped quotes can be
misread.

The script documents the fallback as less reliable, but if the hook is security-sensitive, an
unreliable parser should probably fail closed or make `jq` a hard dependency.

### The hook allows unparseable payloads

If the hook cannot parse a command, it exits `0`. That is convenient, but for a safety hook it
means malformed or unexpected input is allowed by default.

This may be an intentional availability tradeoff, but it should be called out explicitly as a
limitation because it affects the threat model.

### Hook matching can still block non-executed text

The hook's known false positives remain:

- comments containing blocked phrases
- strings containing blocked phrases
- documentation commands echoed to files

That is documented in the test output as a known limitation, but the user-facing hook README does
not mention it. Agents may be surprised when harmless commands are blocked.

### Instructions may over-apply beyond their own descriptions

`instructions/writing.instructions.md` says it applies to `**/*.md`, but its body says it applies
to "README files, blog posts, documentation, copy, comments, commit messages, or any text."

Those scopes are not equivalent. With `applyTo: '**/*.md'`, it will not automatically cover
commit messages or comments in code files. The prose overstates where the instruction applies.

### Prompt bodies contain project-specific assumptions

Several prompt files appear reusable but include assumptions from one style of site:

- `/pre-publish` requires "No em-dashes anywhere"
- `/pre-publish` checks for personal contact info and public GitHub repo links
- `/announce` classifies "Blog post (personal)" with hiking as the example
- `/announce` assumes Twitter/X and LinkedIn as likely active platforms

These may be useful for the author's projects, but they are not fully universal unless framed
as defaults to confirm against AGENTS.md.

### The `pre-publish` prompt can overstate generic publishing requirements

`prompts/pre-publish.prompt.md` requires `<meta name="robots" content="index, follow">` unless
noindex is intentional. Many valid pages omit robots meta entirely because indexing/following is
the default.

As written, the prompt can mark valid pages as failing for not including an unnecessary tag.

### The prompt frontmatter may be tool-specific but is not labeled as such

`prompts/README.md` describes VS Code chat prompt frontmatter with fields such as `agent` and
`tools`. If these are specific to one VS Code/Copilot prompt-file implementation, the README
should say that clearly and link or point to the expected consumer.

Right now it reads as if the format is generally understood by all environments.

---

## Anything Else

### The repo is moving in the right direction but source-of-truth drift remains the pattern

Many previous issues appear to have been addressed: skill counts, BigCommerce pagination,
VPAT freshness, hook input parsing, hook tests, license, context coverage, and overlay model.
The repeated failure mode is not lack of intent. It is duplicated instructions that drift:

- overlay path in README/init vs templates
- hook input contract in script vs hook README
- blocked list in script vs hook README
- heredoc check name vs actual validation behavior
- asset directories in structure docs vs distribution scripts

The highest-leverage improvement is reducing duplicate sources of truth or validating every
copy that must remain duplicated.

### `Gemini_evaluation_report.md` appears to be stale relative to current repo state

The report says `validate.sh` ignores prompts and instructions, which is still true. It also says
`update.sh` "perfectly preserves project context" via `.local.md` overlays, but several docs and
templates still teach the old path. If the report stays in the repo, it should be treated as a
dated artifact rather than authoritative current documentation.

### `.DS_Store` files are present in the working tree

Ignored `.DS_Store` files exist at:

- `.DS_Store`
- `skills/.DS_Store`
- `prompts/.DS_Store`
- `instructions/.DS_Store`

They are ignored and not a source-code issue, but they are local clutter visible in
`git status --ignored`.

### The repo now has three reusable-instruction layers that need routing guidance

The repo has:

- skills: load on task intent
- prompts: invoke manually
- instructions: apply automatically by file pattern

The README explains each separately, but there is no decision matrix for converting an idea into
the right layer. That will matter as the toolkit grows. Without routing rules, future additions
may become prompts when they should be skills, or instructions when they should be project
AGENTS.md guardrails.

### Some universal rules may be personal style rules

The "no em-dashes" rule appears in writing instructions and pre-publish checks. That is valid as
a personal toolkit preference, but it is not a universal engineering or documentation standard.
If this repo is shared as a general toolkit, personal style rules should be labeled as such or
moved into an overlay/profile layer.

### Templates still contain strong examples that may be mistaken for defaults

Some AGENTS templates still include assertive rules that may not apply to all projects of that
type, such as zero-dependency JS libraries, RLS expectations, and specific federal deployment
checks. These can be useful, but they should be clearly marked as examples to keep/delete so
agents do not treat them as universal facts.

---

## Suggested Priority

1. Update all AGENTS templates to the `.local.md` overlay convention.
2. Replace the partial heredoc check with an exact comparison or generate `init.sh` output from
   `templates/agents-default.md`.
3. Fix stale `--force` warnings to distinguish `.local.md` overlays from edited base files.
4. Expand validation to prompts, instructions, context, templates, and full README coverage.
5. Bring `hooks/README.md` back in sync with the hook script: stdin JSON, `jq`, blocked list,
   parse-failure behavior, and known false positives.
6. Decide whether prompts/instructions are personal-profile assets or universal assets, then
   document installation and validation accordingly.
