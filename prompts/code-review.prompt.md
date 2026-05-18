---
name: 'code-review'
description: 'Review code against Pete''s personal standards: no var, no jQuery, accessible, native APIs first, functions small and single-purpose'
agent: 'ask'
---

Review the following code against these standards. Be direct. Flag every violation. Do not soften findings.

${input:code:paste the code to review, or describe the file/PR to examine}

---

## Standards Checklist

**JavaScript**
- No `var` — `const` by default, `let` only when reassignment is needed
- No jQuery unless the project already uses it
- No React for problems vanilla JS can solve
- No unnecessary libraries — prefer native browser APIs
- Functions are small and single-purpose
- No `console.log` left in production code
- No inline event handlers in HTML (`onclick`, `onchange`)
- Async operations use `async/await` not `.then()` chains where possible
- No swallowed errors (`catch` blocks that do nothing)

**Accessibility**
- Interactive elements are keyboard operable
- Images have meaningful `alt` text, or `alt=""` if decorative
- Form inputs have associated `<label>` elements
- Color is not the only means of conveying information
- Focus is visible and logical
- ARIA is used only when native HTML semantics are insufficient

**HTML**
- Semantic elements used correctly (`<nav>`, `<main>`, `<article>`, `<section>` with heading)
- No `<div>` or `<span>` where a semantic element fits
- Headings in correct hierarchy (one `<h1>`, no skipped levels)

**CSS**
- No `!important` in component or layout CSS
- No magic numbers without a comment or custom property
- No inline styles except for truly dynamic values

**Security**
- No credentials, tokens, or secrets in code
- User input is not injected directly into the DOM (`innerHTML`, `document.write`)
- External URLs are not constructed from unvalidated user input

**General**
- `.gitignore` includes `.env` — secrets are not committed
- No commented-out code left in the PR
- No `TODO` comments that aren't tracked somewhere

---

## Output Format

Group findings by severity:

**Must fix** — things that are wrong, will break, or are a security/accessibility risk.
**Should fix** — things that violate the standards but won't immediately cause harm.
**Consider** — suggestions, not requirements.

For each finding: what it is, where it is, and one sentence on why it matters.
If the code is clean, say so plainly — do not invent findings to seem thorough.
