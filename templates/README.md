# templates/

Starter files for wiring up new projects.

---

## What This Is

Templates are the starting point for files that every project needs but always ends up writing
from scratch. Instead of remembering the correct structure every time, copy the relevant template
and fill in the project-specific parts.

The goal is not a complete file — it's a correct skeleton that asks the right questions.

---

## Templates in This Folder

| Template | What It Generates | Use When |
|----------|------------------|----------|
| `agents-default.md` | Blank-slate AGENTS.md | Any new project |
| `agents-static-site.md` | AGENTS.md for a static HTML/Vite site | Building with plain HTML, Vite, Eleventy |
| `agents-js-library.md` | AGENTS.md for an open source JS library | npm packages, standalone tools |
| `agents-web-app.md` | AGENTS.md for a web application | React, Vue, or server-rendered apps |

> `init.sh` uses `agents-default.md` automatically. For project-type-specific starters,
> copy the relevant template manually.

---

## How to Use

```bash
# Copy a template into a new project
cp ~/GitHub/agent-config/templates/agents-static-site.md ./AGENTS.md

# Then fill in the placeholders marked with <!-- -->
```

Placeholders use HTML comment syntax so they're invisible to agents until replaced:
`<!-- Project name -->`, `<!-- Describe the architecture -->`, etc.

---

## What Makes a Good AGENTS.md

An AGENTS.md earns its existence by answering questions the agent would otherwise have to guess:

- **What is this project?** One paragraph. What it does, who it's for, what problem it solves.
- **How do I build and run it?** The exact commands, in order.
- **What's the architecture?** Not every file — the non-obvious parts. What calls what. Where
  the source of truth lives for each concern.
- **What skills are available?** Point to `./skills/` and explain the overlay pattern.
- **What should I never do?** The guardrails. Patterns that look like improvements but aren't.
  Decisions that were made deliberately.

An AGENTS.md that's too short leaves the agent guessing. One that's too long buries the
important parts. The right length is "as short as possible while still preventing the most
common mistakes."

---

## Keeping Templates Current

When you discover a pattern that belongs in every project of a given type — a guardrail that
prevented a real mistake, a build step that's easy to forget — add it to the relevant template.

Templates only improve if they're updated when you learn something new. A template last touched
two years ago is probably wrong about something.
