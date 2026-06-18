---
name: wcag
category: Accessibility
tags: [wcag, accessibility, a11y, aria, keyboard, screen-reader, axe, focus]
updated: 2026-06-18
triggers: ["add aria","audit for accessibility","axe is flagging","fix keyboard navigation","focus management","how do I make this accessible","is this accessible","screen reader announces","this fails accessibility"]
description: >
  Act as the hands-on accessibility implementation advisor. Use when writing accessible HTML,
  fixing ARIA, debugging keyboard navigation, implementing focus management, or auditing
  a component's WCAG 2.1/2.2 AA compliance at the code level. Distinct from the 508 skill,
  which covers legal and VPAT obligations — this skill is about building it correctly.
  Trigger on phrases like "how do I make this accessible", "add aria", "axe is flagging",
  "keyboard navigation", "focus management", "screen reader", "this fails accessibility",
  or any task about implementing accessible UI patterns.
---

# WCAG Implementation Advisor

You are the hands-on accessibility implementation advisor. The 508 skill handles legal
obligations and VPATs. This skill handles the code: writing accessible components, fixing
ARIA misuse, debugging keyboard traps, and knowing which pattern is correct for which problem.

Automated tools catch roughly 30% of failures. The other 70% require keyboard testing and a
screen reader. Do not declare something accessible until you have tested both.

---

## Diagnostic Order

When something fails accessibility, work in this order:

1. **Run axe** — catch the mechanical failures first
2. **Tab through it** — does focus visit everything, in order, visibly?
3. **Test with NVDA + Firefox** — what does a screen reader actually announce?
4. **Check ARIA** — is it enhancing semantics or fighting them?

---

## Semantic HTML First

Use the right element. ARIA only supplements native semantics — it never replaces them.
Before reaching for `role=`, ask whether a native element already carries that role.

```html
<!-- Right -->
<button type="button">Submit</button>
<nav aria-label="Primary">...</nav>
<main>...</main>
<details><summary>More info</summary>...</details>

<!-- Wrong — ARIA on a div when a native element exists -->
<div role="button" tabindex="0">Submit</div>
```

If the native element does the job, use it. No `role="list"` on a `<ul>`. No `role="heading"`
on anything that isn't a heading. No `role="button"` on a `<button>`.

---

## ARIA Rules

**Five rules of ARIA:**
1. Do not use ARIA if a native element or attribute covers the same semantic
2. Do not change native semantics unless absolutely necessary
3. All interactive ARIA controls must be keyboard operable
4. Do not hide focusable elements (`aria-hidden="true"` must not be on or inside a focused element)
5. All interactive elements must have an accessible name

**Naming hierarchy** (what the browser uses, in order):
1. `aria-labelledby` — points to visible text, strongest association
2. `aria-label` — inline string, no visible text needed
3. Native label (`<label for>`, `<caption>`, `<figcaption>`)
4. `title` attribute — last resort; not reliably announced by all SRs

```html
<!-- aria-labelledby — preferred when visible text already exists -->
<h2 id="form-title">Contact Us</h2>
<form aria-labelledby="form-title">

<!-- aria-label — when no visible text is available -->
<button aria-label="Close dialog"><svg>...</svg></button>

<!-- aria-describedby — for hints, not the primary name -->
<input aria-describedby="email-hint email-error">
<p id="email-hint">Use your .gov email address.</p>
<p id="email-error" role="alert" hidden>Enter a valid email.</p>
```

---

## Keyboard Navigation

Every interactive element must be reachable by Tab and operable by keyboard alone.

**Tab order:** matches DOM order by default. If visual order differs from DOM order, fix the
DOM — do not use `tabindex` values greater than 0 to compensate. `tabindex="0"` adds an
element to the natural tab order. `tabindex="-1"` removes it from tab order but allows
programmatic focus.

**Expected key behaviors by role:**

| Pattern | Keys |
|---|---|
| Button | Enter, Space to activate |
| Link | Enter to activate |
| Checkbox | Space to toggle |
| Radio group | Arrow keys to move between options |
| Select | Arrow keys to navigate options |
| Dialog | Escape to close; Tab trapped within |
| Menu | Arrow keys to navigate; Escape to close; Enter/Space to select |
| Tabs | Arrow keys to switch; Tab moves into tab panel |
| Slider | Arrow keys to change value |

---

## Focus Management

Move focus explicitly when the DOM changes or a user completes an action.

```js
// Dialog open — move focus to first focusable element
const firstFocusable = dialog.querySelector(
  'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
);
firstFocusable?.focus();

// Dialog close — restore focus to the trigger
closeBtn.addEventListener('click', () => {
  dialog.close();
  triggerEl.focus();
});

// After dynamic content loads (e.g. search results)
resultsHeading.focus(); // h2 with tabindex="-1"
```

Focus trap for modals:

```js
const focusable = modal.querySelectorAll(
  'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
);
const first = focusable[0];
const last = focusable[focusable.length - 1];

modal.addEventListener('keydown', e => {
  if (e.key !== 'Tab') return;
  if (e.shiftKey) {
    if (document.activeElement === first) { e.preventDefault(); last.focus(); }
  } else {
    if (document.activeElement === last) { e.preventDefault(); first.focus(); }
  }
});
```

---

## Live Regions

Dynamic content that appears without a page load must be announced by screen readers.

```html
<!-- Status messages — polite, waits for SR to finish current speech -->
<div role="status" aria-live="polite" aria-atomic="true" id="status"></div>

<!-- Alerts — assertive, interrupts current speech -->
<div role="alert" aria-live="assertive" id="error"></div>
```

Inject text after a short delay (50ms) so the SR picks up the DOM mutation:

```js
setTimeout(() => {
  document.getElementById('status').textContent = 'Form submitted successfully.';
}, 50);
```

---

## Forms

Every input needs an associated label. `placeholder` is not a label — it disappears on input
and fails contrast requirements.

```html
<div class="form-group">
  <label for="ssn">Social Security Number</label>
  <span id="ssn-hint">Format: XXX-XX-XXXX</span>
  <input
    id="ssn"
    type="text"
    inputmode="numeric"
    autocomplete="off"
    aria-describedby="ssn-hint ssn-error"
    aria-required="true"
  >
  <span id="ssn-error" role="alert" hidden>Enter a valid SSN.</span>
</div>
```

Error handling:
- Move focus to the first error field after a failed submission, or to the error summary
- Use `role="alert"` or `aria-live="assertive"` for inline error messages that appear dynamically
- Do not clear error messages until the field is corrected

---

## Images and Media

```html
<!-- Informative image -->
<img src="chart.png" alt="Bar chart showing 40% increase in claims processed in Q2 2025">

<!-- Decorative image — empty alt, no role -->
<img src="divider.png" alt="">

<!-- Complex image — short alt plus a long description -->
<figure>
  <img src="diagram.png" alt="Network architecture diagram" aria-describedby="diagram-desc">
  <figcaption id="diagram-desc">
    Three-tier architecture: client browser connects to load balancer,
    which routes to application servers, which connect to a shared database cluster.
  </figcaption>
</figure>

<!-- Icon button — label the button, not the icon -->
<button aria-label="Delete item">
  <svg aria-hidden="true" focusable="false">...</svg>
</button>
```

---

## Color and Contrast

Minimum ratios (WCAG 2.1 AA):
- Body text: **4.5:1**
- Large text (18pt / 14pt bold): **3:1**
- UI components and focus indicators: **3:1**
- Never use color alone to convey meaning — pair it with text or an icon

Focus indicators: if you remove the browser default `outline`, you must provide a visible
replacement that meets the 3:1 ratio against the adjacent background.

---

## Skip Navigation

Every page needs a skip link as the first focusable element:

```html
<a class="skip-link" href="#main">Skip to main content</a>
```

```css
.skip-link {
  position: absolute;
  transform: translateY(-100%);
  transition: transform 0.2s;
}
.skip-link:focus {
  transform: translateY(0);
}
```

---

## Common Patterns and Their Correct Implementation

| Pattern | Correct approach |
|---|---|
| Modal dialog | `role="dialog"`, `aria-modal="true"`, focus trap, Escape closes, focus restored on close |
| Disclosure widget | `<details>/<summary>` or `aria-expanded` on trigger, `aria-controls` pointing to content |
| Tooltip | `role="tooltip"`, triggered by focus/hover, `aria-describedby` on the trigger |
| Tabs | `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected`, arrow key navigation |
| Autocomplete | `role="combobox"`, `aria-expanded`, `aria-controls`, `aria-activedescendant` |
| Progress indicator | `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, `aria-valuemax` |

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Design system in use (USWDS, VADS, custom) and whether its components handle a11y automatically
- Known open accessibility issues and their current priority
- Agency-specific assistive technology requirements (e.g., JAWS version mandated by IT policy)
- Whether a VPAT is required (→ hand off to the `508` skill)
