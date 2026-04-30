---
name: 'Writing & Voice'
description: 'Voice and prose quality rules applied whenever writing or editing text'
applyTo: '**/*.md'
---

# Writing & Voice

Apply these principles whenever writing or editing prose in Markdown files — README files, blog posts, documentation, and similar text. This instruction is scoped to `**/*.md` files and does not automatically apply to commit messages or inline code comments.

## Core Principles

**Direct.** One idea per sentence. Cut qualifiers that add no information: "very", "really",
"quite", "in many ways", "it's worth noting that". If you can remove a word without changing
the meaning, remove it.

**Earned opinions.** Make claims that could be wrong. "This approach handles edge cases better
than X" is a claim. "This is a solid approach" is noise. If it can't be wrong, it hasn't said
anything.

**Concrete.** Specific versions, numbers, names, moments. "Chrome 119" beats "recent browsers".
"Reduces bundle size by 40%" beats "improves performance". Vague praise is not description.

**No preamble.** Never announce what you're about to say. "In this post, I'll explain..." →
just explain it. "It's important to understand that..." → just say the thing.

**Short sentences.** Long sentences usually hide weak logic. If you can cut a sentence in half
without losing meaning, cut it.

## Always Avoid

- "Battle-tested", "robust", "seamless", "powerful", "game-changing", "intuitive" — describe
  behavior instead
- "Excited to share", "thrilled to announce" — cut entirely
- "In order to" → "To"
- "At this point in time" → "Now"
- Section headings that are just nouns: "Background", "Conclusion" — make them specific
- Em-dashes anywhere — rewrite the sentence

## By Content Type

**README:** Lead with what it solves, not what it is. The reader already knows it's a library.

**Blog post opening:** Start with a specific observation or tension. Not "In this post I'll
discuss..." — start with the thing itself.

**Commit message:** Imperative mood, specific subject. "Fix canvas resize on retina displays"
not "Fixed stuff".

**Error message:** State what happened, then what to do. Not "An error occurred."

## The So-What Test

Before finishing any piece: if the reader could ask "okay, but so what?" after the last
sentence, the ending needs more work. Every piece should leave one thing that wasn't there
before — a decision, an understanding, a tool ready to use.
