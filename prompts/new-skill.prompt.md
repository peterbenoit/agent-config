---
name: 'new-skill'
description: 'Scaffold a new SKILL.md with correct frontmatter, structure, and the universal/project-specific split'
argument-hint: 'Name of the skill to create (e.g., "database", "api-design")'
agent: 'agent'
tools: ['search/codebase', 'vscode/openFile']
---

Create a new skill file for: ${input:skillName:skill name, e.g. "database" or "api-design"}

Before writing anything, read [skills/README.md](../skills/README.md) to understand
the conventions and the "would I edit this?" universality test.

Then ask:
1. What role does this specialist play? (One sentence: "You are the X. Your job is to Y.")
2. What are the 4–6 most natural trigger phrases someone would use to invoke it?
3. Is this universal (works in any project without editing) or project-specific?
   If project-specific, it belongs in the project repo, not agent-config.

---

## File to Create

`skills/${input:skillName}/SKILL.md`

## Required Structure

```markdown
---
name: '${input:skillName}'
description: >
  [One paragraph. Role definition, when to use it, and 4–6 explicit trigger phrases.
  The description is load-bearing — agents read it to decide whether to load this skill.
  Make it specific enough to not false-trigger, broad enough to catch real cases.]
---

# [Skill Title]

You are the [role] for this project. Your job is to [primary function] — not [what it is not].

---

## [Core Section — methodology, principles, or framework]

[The approach this specialist uses. Not a list of tasks — how they think.]

---

## [Workflow or Checklist — if applicable]

[Step-by-step process or checklist items. Only include if the skill has a repeatable workflow.]

---

## [Examples or Patterns — if applicable]

[Before/after examples, code patterns, or anti-patterns. Make them concrete.]

---

## What Not to Do

[2–4 specific anti-patterns this specialist would catch or prevent.]

---

## Project Context

Check AGENTS.md or local skill overlays for:
- [List the project-specific things this skill would need: URLs, IDs, known issues, etc.]
- [Be specific — these are the prompts that tell the user what to fill in their overlay]
```

---

## After Creating the File

1. Apply the "would I edit this?" test: if a developer on any project could use it immediately
   without changing anything → it's universal. If not → strip the project-specific parts into
   the `## Project Context` section.

2. Add a row to the skills table in `skills/README.md`.

3. Add a row to the root `README.md` skills table.

4. Run `./validate.sh` to check frontmatter and table coverage.
