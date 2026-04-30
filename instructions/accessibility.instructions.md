---
name: 'Accessibility Baseline'
description: 'WCAG 2.1 AA rules applied automatically to every HTML file'
applyTo: '**/*.html'
---

# Accessibility Baseline

Apply these rules to every HTML file without exception. These are not audit criteria —
they are construction standards. Build them in from the start rather than fixing them later.

## Required on Every Page

- One `<h1>` per page. Heading hierarchy must be logical — no skipped levels.
- `<main id="main-content">` wraps primary content. Footer lives outside `</main>`.
- `<nav>` elements have `aria-label` to distinguish multiple navigation regions.
- `<footer>` has `aria-label="Site footer"`.
- `<html>` has a `lang` attribute matching the page language.
- `<meta charset="utf-8">` is present.
- `<title>` is present, unique, and descriptive.
- `<meta name="description">` is present.

## Images

- Every `<img>` has an `alt` attribute. No exceptions.
- Decorative images: `alt=""` and `aria-hidden="true"`.
- Meaningful images: alt text describes the content, not the file name.
- Never use an image as the only way to convey information.

## Interactive Elements

- Every button has an accessible name — visible text or `aria-label`.
- Every link has meaningful text. Not "click here", "read more", "learn more".
- Focus order follows visual reading order.
- Focus is visible — never suppress with `outline: none` without a replacement.
- No keyboard traps.
- Custom controls (dropdowns, modals, accordions) implement correct ARIA roles
  and respond to keyboard events.

## Forms

- Every input has an associated `<label>` (via `for`/`id` or `aria-labelledby`).
- Required fields are marked in a way that does not rely on color alone.
- Error messages are associated with their field via `aria-describedby`.
- Form submission errors are announced to screen readers.

## Icons

- Decorative icons: `<svg aria-hidden="true">`.
- Standalone icon links: `aria-label` on the parent `<a>`, `aria-hidden="true"` on `<svg>`.
- Never inline SVG markup when a sprite system exists — use `<use href="...">`.

## Color & Motion

- Text contrast: 4.5:1 minimum for normal text (< 18px), 3:1 for large text.
- UI components and focus indicators: 3:1 minimum.
- Information is never conveyed by color alone.
- Animations respect `prefers-reduced-motion`.
- Nothing flashes more than 3 times per second.

## Mobile

- Touch targets are at least 44×44px.
- Content reflows without horizontal scrolling at 320px viewport width.
- `user-scalable=no` is never used.

## Never

- Never disable accessibility features to meet a deadline. Flag the conflict instead.
- Never use `tabindex` values greater than 0.
- Never add `role="presentation"` or `aria-hidden="true"` to focusable elements.
- Never ship a change that introduces a new accessibility blocker.
