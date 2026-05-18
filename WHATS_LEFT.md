6 items left, and they're all related:

9, 10, 11 — new frontmatter fields (requires:, agents:, triggers:). These add metadata to all 27 SKILL.md files. Decent amount of work, debatable whether the payoff is worth it.
13 — per-skill README.md files. More documentation overhead, lower utility.
14 — .env.example per skill that needs API keys. Only relevant for a few skills (analytics, bigcommerce maybe).
23 — validate that requires: is documented in the skill body. Depends on item 9.
Items 9/10/11 are the heaviest — they'd mean editing all 27 skills again. Item 23 is free once 9 is done. Items 13 and 14 are probably the most skippable; per-skill READMEs duplicate what description: already covers.

My honest read: 9 and 11 have real value (agents want structured trigger lists, not buried text). 10 and 13 are nice-to-have. 14 and 23 are narrow edge cases. But that's your call when you're back.
