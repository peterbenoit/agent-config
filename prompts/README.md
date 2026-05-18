# prompts/

Reusable slash commands invoked manually in chat.

---

## What Prompts Are

Prompt files are on-demand workflows you trigger with a `/` command in VSCode chat.
Unlike instructions (which are always-on), prompts only run when you explicitly invoke them.

Think of them as saved procedures for tasks you do repeatedly but don't want to retype:
`/pre-publish`, `/new-skill`, `/announce`. Each one bundles the full workflow — the checks,
the steps, the output format — into a single command.

---

## Format

```markdown
---
name: 'command-name'
description: 'What this does, shown in the command picker'
argument-hint: 'Optional hint shown in chat input after /command-name'
agent: 'agent'
tools: ['search/codebase', 'vscode/openFile']
---

Prompt body. Plain markdown. Full instructions for the task.
Can reference workspace files with relative links: [AGENTS.md](../AGENTS.md)
Can prompt for user input with: ${input:variableName:placeholder text}
```

**`agent` values:**
- `agent` — autonomous, can read/write files and run tools (default for most prompts)
- `ask` — chat only, no file edits
- `edit` — inline edits mode

**Invoking:** type `/command-name` in the VSCode chat input.

---

## Files in This Folder

| File | Command | What It Does |
|------|---------|-------------|
| `pre-publish.prompt.md` | `/pre-publish` | Run QA, SEO, accessibility, and security checks before publishing |
| `new-skill.prompt.md` | `/new-skill` | Scaffold a new SKILL.md with correct frontmatter and structure |
| `announce.prompt.md` | `/announce` | Generate platform-appropriate social copy for new content |
| `weekly-review.prompt.md` | `/weekly-review` | Run the analytics weekly check-in workflow |
| `diagnose.prompt.md` | `/diagnose` | Full agent-config health check — validate, symlinks, skill count, version |
| `code-review.prompt.md` | `/code-review` | Structured code review against Pete's personal standards |
| `accessibility-audit.prompt.md` | `/accessibility-audit` | Full 508/WCAG 2.1 AA audit workflow with prioritized findings report |

---

## What Belongs Here vs. Instructions vs. Skills

**Prompts** — things you invoke deliberately for a specific task. Finite scope.
"Run these 8 checks on this page before I publish it."

**Instructions** — ambient rules applied to every matching file automatically.
"Always write accessible HTML."

**Skills** — methodology and role definitions, loaded when the agent recognizes the task.
"When I ask about SEO, here's how to think about it."

A good test: would you want this to run every time, or only when you ask?
If only when you ask → prompt. If every time → instruction.
