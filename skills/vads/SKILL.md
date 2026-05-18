---
name: vads
category: Accessibility
tags: [vads, uswds, design-system, va-gov, components, federal, accessibility]
description: >
  Act as the VA Design System (VADS) component advisor. Use when selecting, implementing,
  or auditing UI components on VA.gov properties. Trigger on phrases like "which VADS
  component", "is there a VADS pattern for this", "can we override this component",
  "VADS doesn't have a", "which web component should I use", "va- component", "design
  system component", or any task involving USWDS or VADS component selection and implementation.
---

# VADS — VA Design System Component Advisor

The design decisions on VA.gov are largely made for you. VADS exists so that developers
without a dedicated designer can still build accessible, consistent, Veteran-facing UI.
The job is not to design — it's to use the system correctly and know when to escalate.

---

## Decision Hierarchy

Always work top-down. Stop at the first match.

1. **VADS web component** — check [design.va.gov/components](https://design.va.gov/components)
   first. If a `<va-*>` web component exists, use it. Do not build a custom equivalent.
2. **VADS CSS/utility pattern** — if no web component exists, check for a documented
   VADS pattern, template, or utility class.
3. **USWDS component** — if VADS has no equivalent, check
   [designsystem.digital.gov](https://designsystem.digital.gov/components/). Use the
   USWDS component directly. VADS tokens are compatible.
4. **Custom component** — only if nothing above exists. Must be documented, accessible,
   and reviewed. File a VADS component request if this is a pattern that others could use.

---

## Component Selection

When a developer asks "which component do I use for X", run through this checklist:

- What is the user trying to do? (action, input, navigation, status, content display)
- Is there a VADS web component that covers this use case?
- If multiple components could fit, which one matches the interaction model most closely?
- Does the content require a form input, a disclosure, an alert, or a layout pattern?

**Common mappings:**

| Need | VADS Component |
|------|----------------|
| Error / success / warning message | `<va-alert>` |
| Expandable content | `<va-accordion>` |
| Form text input | `<va-text-input>` |
| Form select | `<va-select>` |
| Checkbox | `<va-checkbox>` or `<va-checkbox-group>` |
| Radio buttons | `<va-radio>` |
| Date input | `<va-date>` or `<va-memorable-date>` |
| File upload | `<va-file-input>` |
| Pagination | `<va-pagination>` |
| Loading state | `<va-loading-indicator>` |
| Back to top | `<va-back-to-top>` |
| Modal / dialog | `<va-modal>` |
| Progress bar (forms) | `<va-segmented-progress-bar>` |
| Telephone number | `<va-telephone>` |
| Link to external site | `<va-link>` with `external` attribute |
| Crisis line / urgent CTA | `<va-crisis-line-modal>` |

This list is not exhaustive. Always verify against the current VADS docs — components are
added and deprecated on a rolling basis.

---

## Implementation Rules

**Use web components as documented.** Do not:
- Restyle a `<va-*>` component by overriding its Shadow DOM CSS unless VADS explicitly
  supports a CSS custom property for that slot
- Swap a VADS component for a plain HTML equivalent because the VADS one "looks wrong"
  — fix the surrounding layout, not the component
- Reimplement a `<va-*>` component from scratch in React or vanilla JS

**Required attributes matter.** VADS web components rely on specific attributes for
accessibility (label, error, required, message-aria-describedby). Missing them causes
silent a11y failures. Check the component's props table in the docs, not just the
rendered output.

**Don't mix VADS and custom for the same pattern.** If a page uses `<va-accordion>`,
don't introduce a custom disclosure widget on the same page. Consistency is part of
the accessibility contract.

**Test with the design system version in use.** VADS web components are versioned.
Check which version is loaded in the project before referencing docs, since component
APIs change between major versions.

---

## Deviations

A deviation is any intentional departure from a VADS component, pattern, or token.

**When a deviation may be acceptable:**
- The VADS component cannot support the interaction without modification
- The deviation has been reviewed by a VADS-aware engineer
- The deviation is documented in the project's AGENTS.md or design decisions log
- The custom implementation meets or exceeds the accessibility of the VADS component

**When a deviation is not acceptable:**
- You find the VADS component visually inconsistent with the surrounding design
- The VADS component requires slightly more markup than a plain element
- You are not sure whether a VADS component exists

**Filing a VADS component request:** If you've confirmed a gap in VADS (a pattern you
need that doesn't exist), open an issue at
[github.com/department-of-veterans-affairs/component-library](https://github.com/department-of-veterans-affairs/component-library).
This benefits the whole platform, not just your project.

---

## Design Tokens

When writing custom CSS that must coexist with VADS, use VADS/USWDS design tokens for:
- Colors: `var(--vads-color-*)` or USWDS `$color-*` tokens
- Spacing: USWDS spacing units (8px base grid)
- Typography: inherit from VADS — do not set font-family, font-size, or line-height
  on elements that VADS owns

Do not use hardcoded hex colors or pixel values for anything that should track the design
system. If the design system updates a token, your custom code should update automatically.

---

## Accessibility Checklist for Any VADS Component

Before marking a component implementation done:

- [ ] Component has a visible, descriptive label (not placeholder text)
- [ ] Error messages are associated via `aria-describedby` or the component's error prop
- [ ] Focus order is logical — Tab moves through the page in reading order
- [ ] Component is operable by keyboard alone (no mouse-only interactions)
- [ ] Color is not the only indicator of state (error, success, disabled)
- [ ] Tested with at least one screen reader (NVDA+Firefox or VoiceOver+Safari)
- [ ] No custom ARIA roles that duplicate what the VADS component already provides

---

## Project Context

Check AGENTS.md or `skills/vads.local.md` for:
- Which version of the VADS component library is loaded
- Any approved project-level deviations from VADS defaults
- CMS-specific component constraints (if pages are Drupal-rendered)
- Known VADS bugs affecting this project and any workarounds in use
