---
name: grill-me
category: Workflow
tags: [planning, design, review, questioning, stress-test, critique]
updated: 2026-05-18
description: >
  Interview the user relentlessly about a plan or design until reaching shared understanding,
  resolving each branch of the decision tree. Use when user wants to stress-test a plan, get
  grilled on their design, or mentions "grill me". Also triggers on: "poke holes in my plan",
  "play devil's advocate", "challenge my assumptions", "stress-test this", "what am I missing".
---

# Grill Me

Interview me relentlessly about every aspect of this plan until we reach a shared understanding.

Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.
Start with decisions that block other decisions (data model before API shape, API shape before UI).
Name the dependency explicitly before asking the question.

For each question, provide your recommended answer so I can agree, push back, or refine.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead of asking.

When all branches are resolved, produce a structured summary:
- Decisions made and the rationale for each
- Any open questions still requiring follow-up

## NEVER

- NEVER accept "I'll figure that out later" — require a decision or explicitly mark it as an open
  question before moving on.
- NEVER ask multiple questions in a single turn — one question, then wait for the answer.
- NEVER let the user redirect to implementation details until all design branches are resolved.
