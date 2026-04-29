# Project Name

Short description of what this project is and does.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>/SKILL.md` — the agent reads both; the local file wins on conflicts.

## Context

If this project has a CONTEXT.md in the root, read it before starting any task.
It defines domain-specific terms, key system relationships, and decisions that should
not be silently reversed. AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
# Add your build commands here
```

## Architecture

<!-- Describe the structure of this project: what calls what, where the source of truth
     lives for each concern, and any non-obvious dependencies. -->

## What Not to Do

<!-- Add project-specific guardrails here: patterns that look like improvements but aren't,
     decisions that were made deliberately, and anything that should never be changed silently. -->
