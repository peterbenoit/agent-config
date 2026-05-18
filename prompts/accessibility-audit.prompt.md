---
name: 'accessibility-audit'
description: 'Full 508/WCAG 2.1 AA accessibility audit workflow — produces a prioritized findings report'
argument-hint: 'URL, component name, or paste HTML to audit'
agent: 'ask'
---

Run a full accessibility audit for: ${input:target:URL, component name, or paste the HTML to audit}

Read [skills/508/SKILL.md](../skills/508/SKILL.md) and [skills/qa/SKILL.md](../skills/qa/SKILL.md) for the audit framework and WCAG criteria.

---

## Audit Scope

Work through each category in order. Do not skip a section because it looks clean — document
what was checked even when the result is a pass.

### 1. Keyboard Navigation
- Tab through all interactive elements in logical order
- Every interactive element reachable by keyboard only
- Focus indicator visible at all points
- No keyboard traps (can always tab out of a component)
- Custom widgets (dropdowns, modals, tabs) implement ARIA keyboard patterns correctly

### 2. Screen Reader Behavior
- Page title is descriptive and unique
- Landmarks present: `<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>` where appropriate
- Heading hierarchy: one `<h1>`, no skipped levels, logical outline
- Images: meaningful `alt` text, or `alt=""` for decorative
- Form inputs: associated `<label>` for every control
- Error messages programmatically associated with the field in error
- Dynamic content changes announced (live regions if needed)
- Links and buttons have descriptive text (no "click here", no "read more" without context)

### 3. Color and Contrast
- Text contrast ≥ 4.5:1 (normal text), ≥ 3:1 (large text ≥18pt or ≥14pt bold)
- UI component contrast ≥ 3:1 (borders, icons, focus rings)
- Information is not conveyed by color alone (error states, charts, status indicators)

### 4. Content and Language
- Page `lang` attribute set correctly
- Any inline language change uses `lang` attribute on the element
- Reading level appropriate for the audience (federal: aim for 8th grade or below)
- Abbreviations and acronyms expanded on first use

### 5. Forms
- All inputs labeled (visible label or aria-label)
- Required fields indicated (not by color alone)
- Error messages describe the problem and how to fix it
- No timeout without warning, or timeout can be extended

### 6. Images and Media
- All informational images have descriptive `alt` text
- Complex images (charts, diagrams) have extended descriptions
- Video has captions (synchronized, accurate)
- Audio has a transcript
- No auto-playing audio > 3 seconds without a pause control

### 7. Motion and Animation
- Animations respect `prefers-reduced-motion`
- No content flashes more than 3 times per second (seizure risk)
- Parallax and large motion effects disabled or reduced when preference is set

### 8. Resize and Zoom
- Page is usable at 200% zoom without horizontal scroll (400% for WCAG 2.1 AAA reference)
- No loss of content or functionality at large text sizes
- Touch targets ≥ 44×44px (WCAG 2.5.5)

---

## Output Format

### Summary

```
Audit target: [URL or component]
Date: [today]
Standard: WCAG 2.1 Level AA / Section 508
Total findings: [N critical, N serious, N moderate, N minor]
```

### Findings

Group by severity. For each finding:

**[CRITICAL / SERIOUS / MODERATE / MINOR]** — [WCAG criterion, e.g., 1.1.1 Non-text Content]
- What: [description of the issue]
- Where: [element, selector, or location]
- Impact: [who is affected and how]
- Fix: [specific remediation]

### Passes

List what was checked and passed. Do not skip this section — it establishes what was actually reviewed.

### Not Tested

List anything outside scope (e.g., "video captions not tested — no video present on this page").
