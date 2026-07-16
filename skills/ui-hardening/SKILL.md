---
name: ui-hardening
category: Frontend
tags: [frontend, resilience, edge-cases, states, responsive, i18n, rtl, forms, production]
updated: 2026-07-16
triggers: ["harden this UI","production ready","edge cases","empty state","loading state","error state","long content","internationalization","RTL","what happens when this fails"]
description: >
  Make web interfaces production-ready across adverse data, asynchronous states, constrained
  layouts, input methods, localization, and failure conditions. Use when hardening a page or
  component, reviewing edge cases, or implementing loading, empty, partial, error, offline,
  disabled, and recovery states. Trigger on phrases like "harden this UI", "production ready",
  "edge cases", "empty state", "loading state", "error state", "long content", "RTL", or "what
  happens when this fails". Use `qa` for a broad release audit and `wcag` for accessibility-specific
  remediation.
---

# UI Hardening

Make the interface survive real data, real networks, real devices, and real users. The happy path
is only one state of the product.

## Build a State Inventory

Before changing code, list the states that can actually occur:

- Initial, loading, refreshing, pending, and completed
- Empty because nothing exists versus empty because filters found nothing
- Partial data, stale data, missing fields, and delayed dependencies
- Validation, permission, network, server, timeout, offline, and unknown errors
- Success that is immediate, delayed, optimistic, or reversible
- Disabled due to permissions, prerequisites, limits, or in-progress work

Define which states can overlap. A refreshing screen may still show stale content; an optimistic
item may also fail and require recovery.

## Async and Failure States

- Preserve useful existing content during background refreshes.
- Use skeletons only when the layout is predictable; otherwise prefer a compact progress state.
- Prevent duplicate submissions while making pending state visible.
- Keep error messages specific: what happened, what was preserved, and what can be tried next.
- Put retry actions near the failure they affect.
- Distinguish permission failures from temporary technical failures.
- Design optimistic updates with rollback, reconciliation, and duplicate-event handling.
- Do not erase user input after a failed submission.

## Data Extremes

Test with:

- Missing names, images, descriptions, and optional metadata
- One item, zero items, and hundreds of items
- Very long unbroken values, URLs, identifiers, and file names
- Large numbers, negative values, zero, and unknown values
- Duplicate labels and similar items that require disambiguation
- User-generated markup or unsafe strings

Prefer wrapping and resilient layout before truncation. When truncation is necessary, preserve
access to the full value and keep the accessible name useful.

## Forms and Actions

- Keep labels, instructions, requirements, and errors visible and associated with controls.
- Validate at a time that helps correction; do not show an error before the user has had a chance
  to provide input.
- Provide an error summary for long or multi-section forms when appropriate.
- Confirm destructive actions in proportion to consequence and reversibility.
- Make irreversible action language precise.
- Handle expired sessions and conflicts without silently discarding work.
- Preserve focus and announce important asynchronous results.

Use `wcag` for detailed semantics, keyboard behavior, ARIA, and focus remediation.

## Layout and Input Resilience

- Test at narrow containers, not just common full-page viewport widths.
- Support zoom and text resizing without clipped controls or hidden content.
- Account for touch, mouse, keyboard, stylus, hover-capable, and non-hover input.
- Keep touch targets large enough without assuming every pointer is coarse.
- Avoid interactions available only on hover.
- Test mobile browser chrome, safe areas, and the on-screen keyboard where relevant.
- Ensure sticky and fixed UI does not cover focused fields, errors, or anchored content.
- Rework dense tables or toolbars intentionally instead of merely adding horizontal scrolling.

## Localization and Direction

- Allow labels and controls to expand substantially without overlap.
- Use locale-aware APIs for dates, times, numbers, currencies, plurals, and lists.
- Do not concatenate translated fragments into sentences.
- Avoid embedding text in raster images.
- Use logical CSS properties such as `margin-inline` and `inset-inline-start` where direction may
  change.
- Mirror directional icons only when their meaning is spatial rather than conventional.
- Test bidirectional content, not just an all-RTL mockup.

## Themes and User Preferences

- Verify light, dark, forced-colors, and increased-contrast behavior supported by the project.
- Respect reduced motion and reduced data preferences when applicable.
- Do not use disabled-looking visual treatment for elements that remain interactive.
- Preserve visible focus and current/selected state in every theme.
- Verify system controls, autofill, selection, placeholders, and validation colors.

## Hardening Workflow

1. Inspect the data contract and async transitions.
2. Build the state and edge-case inventory.
3. Create representative fixtures for each consequential state.
4. Render at narrow, typical, and wide containers with long content and large text.
5. Exercise keyboard, pointer, touch, offline, slow-network, and failure paths as relevant.
6. Test localization, RTL, themes, and user preferences supported by the product.
7. Add automated coverage for states likely to regress.
8. Document any intentionally unsupported condition.

## Done Means

- Every reachable state has an intentional presentation and recovery path.
- User work is preserved whenever technically possible.
- The layout handles realistic extremes without hiding essential information.
- Actions remain understandable while pending, disabled, failed, or completed.
- Supported locales, directions, input methods, and preferences behave correctly.
- Tests cover the highest-risk state transitions and regressions.

## Project Context

Check AGENTS.md or local skill overlays for:

- API state model, error shapes, permissions, and retry behavior
- Supported browsers, devices, locales, directions, and themes
- Product rules for optimistic updates and destructive actions
- Existing loading, empty, error, toast, dialog, and form patterns
- Analytics or support evidence about common user failures
- Test fixtures and commands for simulating adverse conditions
