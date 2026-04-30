# instructions/

Always-on rules injected automatically into every matching chat session.

---

## What Instructions Are

Instructions files are automatically loaded when the agent works on files matching
their `applyTo` pattern. You never invoke them — they're ambient. The agent reads them
the same way it reads AGENTS.md, but scoped to the file type.

Think of them as standing rules that would be annoying to repeat on every task:
"always write accessible HTML", "never commit secrets", "use the voice principles when
writing prose". They belong here, not in the chat prompt, not in AGENTS.md.

---

## Format

```markdown
---
name: 'Descriptive Name'
description: 'One line explaining what this enforces'
applyTo: 'glob-pattern'
---

# Instructions body
Plain markdown. Rules, constraints, examples.
```

**`applyTo` patterns:**
- `'**'` — applies to every file, always
- `'**/*.ts'` — TypeScript files only
- `'**/*.html'` — HTML files only
- `'**/*.md'` — Markdown/prose files
- `'src/**'` — everything in src/

---

## Files in This Folder

| File | Applies To | What It Enforces |
|------|-----------|-----------------|
| `writing.instructions.md` | `**/*.md`, prose tasks | Voice principles, no marketing language, no preamble |
| `accessibility.instructions.md` | `**/*.html` | WCAG 2.1 AA baseline — landmarks, alt text, focus states |
| `security.instructions.md` | `**` | Never commit secrets, no credentials in source, audit deps |

---

## What Belongs Here vs. AGENTS.md vs. Skills

**Instructions** — rules that apply automatically to specific file types. Scoped, ambient,
non-negotiable. "When writing HTML, always..." or "When working on any file, never..."

**AGENTS.md** — project architecture, build commands, guardrails specific to this codebase.
Read once at session start. Not file-scoped.

**Skills** — loaded on demand when the task matches. Contain methodology, checklists,
workflows. Not ambient — only active when triggered.

If a rule belongs on every HTML file regardless of task, it's an instruction.
If a rule only matters when you're doing an accessibility audit, it's a skill.
