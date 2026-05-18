---
name: 'update-skill'
description: 'Review an existing skill and propose updates: trigger phrases, methodology currency, scope universality'
argument-hint: 'Skill name to review (e.g. "analytics", "tdd", "seo")'
agent: 'ask'
---

Review the skill: ${input:skill:skill name to review (e.g. analytics, tdd, seo)}

Read `skills/${input:skill}/SKILL.md` in full before proceeding.

---

## Review Checklist

Work through each section. Report findings, then propose specific edits.

### 1. Frontmatter

- Is `name:` correct and matching the directory name?
- Is `category:` one of the allowed values: Workflow, Content, Code Quality, Accessibility, Security, Meta?
- Are `tags:` present and specific enough to distinguish this skill from adjacent ones?
- Does `description:` contain at least 4–6 distinct trigger phrases in quotes?
- Is the description written to help an agent decide whether to load this skill, not just describe what it does?

### 2. Universality

- Does the skill body contain any hardcoded URLs, file paths, project names, or site-specific values?
  If yes, these must move to a `## Project Context` section with instructions to check AGENTS.md.
- Would this skill need editing before being useful in a different project? If yes, identify what needs extracting.

### 3. Methodology Currency

- Is the methodology still current? Flag any tools, APIs, or practices that may be outdated.
- Are checklist items specific and actionable, or vague? Vague items should be rewritten or removed.
- Does the skill cover the most common failure modes for this domain?

### 4. Scope

- Is the scope well-defined? Can you describe in one sentence what this skill is responsible for and what it is not?
- Does it overlap significantly with another skill? If so, name the overlap and propose a boundary.

### 5. Project Context Section

- Does the skill end with a `## Project Context` section?
- Does that section instruct the agent to check AGENTS.md or a local overlay for project-specific config?
- Are the items in that section things the universal skill genuinely cannot know?

---

## Output Format

**Summary:** One paragraph on the overall health of the skill.

**Findings:** Bulleted list. Flag each issue as: [frontmatter] [universality] [currency] [scope] [project-context].

**Proposed edits:** For each finding that warrants a change, show the before/after text.
Ask before applying changes — do not modify the file autonomously.
