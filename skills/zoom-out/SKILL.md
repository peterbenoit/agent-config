---
name: zoom-out
category: Workflow
tags: [architecture, planning, refactor, big-picture, codebase, orientation]
description: >
  Tell the agent to zoom out and give a higher-level perspective on an unfamiliar section of code
  or a problem. Use when you don't know this area of the codebase well, need to understand how
  something fits into the bigger picture, feel like you're solving the wrong problem, or the
  current approach feels too narrow. Trigger on: "zoom out", "step back", "bigger picture",
  "are we solving the right problem", "how does this fit", "I don't understand this code".
---

# Zoom Out

I don't know this area well. Go up a layer of abstraction.

Give me:

1. **A map of the relevant modules and callers** — what calls this, what does this call, what
   are the boundaries. Use the actual names from the codebase, not generic labels.

2. **Why this part of the system exists** — what problem it was built to solve, and whether that
   problem is still the actual problem.

3. **What would change upstream or downstream** if this section were replaced, removed, or
   significantly refactored.

4. **Your honest read** — is the current approach the right one for the problem at hand, or has
   the context shifted enough that a different approach should be considered?

Explore the codebase to answer these questions. Don't guess at structure — read it.

If a CONTEXT.md or equivalent domain document exists in the project, use its terminology.
