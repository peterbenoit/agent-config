---
name: 'new-context'
description: 'Scaffold a new context file for a technology or platform domain'
argument-hint: 'Name of the technology or platform (e.g. "node-api", "shopify", "wordpress")'
agent: 'agent'
---

Create a new context file for: ${input:domain:name of the technology or platform}

---

## What a Context File Is

A context file is a domain briefing, not a set of instructions. It gives an agent background
knowledge about a technology or platform so it uses the right vocabulary, understands the key
relationships, and avoids common mistakes — without you having to explain it every session.

Context files live in `context/`. They are loaded on demand, not automatically.

---

## Steps

1. Determine the filename: `context/${input:domain}.md`

2. Check whether a context file for this domain already exists. If it does, report that
   and stop — do not overwrite it.

3. Create the file using this structure:

```markdown
# CONTEXT — {Domain Name}

{One to two sentences: what this technology is, when it's used, and what kind of work
this context file is meant to support.}

---

## Glossary

Terms with a specific meaning in this domain. Included because agents not familiar with
{domain} may use the wrong word or conflate related concepts.

**{Term}** — {definition, including what it is NOT to prevent confusion with similar terms}

<!-- Add 8-12 terms minimum. Prioritize terms that are overloaded or domain-specific. -->

---

## Key Relationships

How the major components relate to each other. This is not a tutorial — it's the mental
model an agent needs to avoid wrong assumptions.

- {Component A} and {Component B}: ...
- {Term X} is not the same as {Term Y}: ...

---

## Common Decisions

Choices that come up repeatedly and have a preferred answer for this kind of project.

| Decision | Preferred approach | Why |
|----------|-------------------|-----|
| ... | ... | ... |

---

## Failure Modes / Gotchas

Things that commonly go wrong and are hard to diagnose without domain knowledge.

- **{Gotcha}** — {what happens, why it's confusing, how to recognize it}

---

## Project Context

Check AGENTS.md or a local context overlay for:
- {list of project-specific things this file can't know: versions, environment, known issues}
```

4. Add the new file to `context/README.md` in the templates table.

5. Report the file path and a one-sentence summary of what was created.
