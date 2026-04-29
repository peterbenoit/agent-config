# refactor — Deferred Skill

This folder is a placeholder. A `refactor` skill has not been written yet because the use case
isn't differentiated enough from what already exists.

---

## The Problem with Writing It Now

A refactor skill would need to give an agent a methodology for improving code structure without
changing behavior. That methodology exists — extract function, replace conditional with
polymorphism, reduce coupling, etc. — but the friction isn't the lack of a skill.

The actual friction is: when someone asks for a refactor, what they usually need first is
**understanding** (why is this code the shape it is?), which `zoom-out` covers. The actual
refactor is then just implementation.

Writing a refactor skill now would produce either:
- A list of refactoring patterns (useful, but better served by a reference link than a skill)
- Vague principles ("improve cohesion", "reduce complexity") that don't change agent behavior

---

## When to Write This Skill

Write `refactor/SKILL.md` when you hit a specific case where:

1. You asked an agent to refactor something and `zoom-out` didn't set it up correctly
2. The agent made changes that altered behavior (regression), suggesting it needs guardrails
3. You have a concrete methodology you want enforced — e.g., "always extract before you inline",
   "never change behavior and rename in the same commit", "test coverage must pass before and after"

Until then, the workflow is: `zoom-out` to understand → implementation with clear scope.

---

## If You Write It

The most valuable content would be **guardrails**, not patterns:

- Never change behavior and structure in the same commit
- Confirm test coverage passes before starting and after finishing
- Rename last — renaming while refactoring makes diffs unreadable
- Extract don't delete — move code before removing the old location, verify callers, then remove
- One concern per PR — don't couple a refactor with a feature

Trigger phrases that would distinguish it:
- "refactor this without changing behavior"
- "clean this up"
- "this is a mess, make it readable"
- "extract this into its own function/module"
