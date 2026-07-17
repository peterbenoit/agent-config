---
name: diverge-first
category: Workflow
tags: [planning, ideation, decision-making, prototyping, personal]
updated: 2026-07-17
requires: []
triggers: ["how should I approach this", "help me think through", "what are my options", "I want to build something for", "not sure how to attack this", "new idea"]
description: >
  Before committing to a direction on an open-ended or high-stakes problem, surface 3-5
  genuinely different approaches and let Pete pick a direction before any design or
  implementation work starts. Use at the start of a new idea or when a decision is hard to
  reverse later. Trigger on phrases like "how should I approach this", "help me think through",
  "what are my options", "not sure how to attack this", or "new idea". Do not use for routine
  implementation requests, bug fixes, or work on an already-locked-in design — those go
  straight to execution.
---

# Diverge First

Based on Will Ness's frontend prototyping approach
(https://twitter.com/WillNessAI/status/1813152814866006202).

## Role

Pete's mental model on a new problem is a starting point, not the answer. Before writing a
design doc, a plan, or code for an open-ended ask, generate real alternatives so the choice of
direction gets made deliberately instead of by default to the first idea in the room.

## When to use this

Only at genuine decision points, not on every task:

- The start of a new idea, feature, or project with no locked-in shape yet
- Pete asks how to approach something, or describes a problem without a solution attached
- The decision is expensive to reverse later (architecture, tech choice, product positioning,
  scope boundaries)

## When NOT to use this

Go straight to execution:

- Pete asks for a specific, scoped implementation ("write a function that does X")
- Debugging or fixing something broken
- Continuing work on a design that's already been decided
- Routine, low-stakes tasks — most of the day-to-day work in this repo

If unsure whether a request qualifies, default to NOT triggering. Interrupting Pete on routine
work is a worse failure than occasionally missing a spot where this would have helped — he
works fast and does not want to be stopped for permission on things that don't need it.

## Methodology

1. **Diverge.** Present 3-5 approaches that are actually different from each other, not
   variations on the same idea. Vary at least one of: architecture/tech, UX paradigm, scope
   boundary, or constraint set. Each gets a short name, a one-line pitch, and the real
   trade-off (not just upside).
2. **Show a picker.** Prefer a compact comparison — a markdown table or a short numbered list
   is enough. If `visualize:show_widget` is available in this session, use it for a
   side-by-side card or table layout; otherwise a plain markdown table works fine and should
   not be treated as a fallback of last resort.
3. **Get feedback.** Ask which approach(es) appeal, and what Pete likes or dislikes about each.
   One round of this, not a survey.
4. **Hand off to `grill-me`.** Once Pete picks a direction (or a hybrid), stop diverging and
   switch to the `grill-me` skill to interrogate and lock down the details of that one
   direction. Don't re-implement that interrogation loop here — `grill-me` already owns it.
5. **Loop back only on request.** If feedback during the drill-down surfaces a fundamentally
   different angle, return to step 1. Don't loop back just because a detail is unresolved —
   that's what `grill-me` is for.

## What success looks like

Pete engages with real alternatives instead of rubber-stamping the first idea, and surfaces a
constraint he hadn't considered before committing. He makes better architecture, positioning,
or scope bets because he saw the trade-offs up front — not because he was quizzed on
implementation details he already knew he wanted.
