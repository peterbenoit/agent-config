---
name: frontend-testing
category: Frontend
tags: [testing, frontend, component-testing, integration, e2e, playwright, vitest, visual-regression, accessibility]
updated: 2026-07-16
triggers: ["test this component","frontend tests","Playwright test","component test","end-to-end test","visual regression","cross-browser test","test the loading state"]
description: >
  Act as the frontend testing advisor for browser interfaces. Use when choosing a test level,
  writing component or integration tests, building Playwright-style end-to-end coverage, testing
  responsive and keyboard behavior, adding visual regression checks, or diagnosing flaky UI tests.
  Trigger on phrases like "test this component", "frontend tests", "Playwright test", "component
  test", "end-to-end test", "visual regression", "cross-browser test", or "test the loading
  state". Use `tdd` when the user explicitly requests a red-green-refactor development loop.
---

# Frontend Testing Advisor

Test behavior through the interface a user or consuming component can observe. Choose the smallest
test level that gives meaningful confidence, then verify critical paths in a real browser.

## Choose the Test Level

| Level | Use for | Avoid using it for |
|---|---|---|
| Unit | Pure transforms, parsers, reducers, token logic | DOM behavior already covered through a component |
| Component | Rendering, input, emitted events, accessible states | Full routing, authentication, or backend integration |
| Integration | Several components, stores, routing, and mocked service boundaries | Browser-engine behavior that requires a real browser |
| End-to-end | Critical journeys, browser APIs, navigation, focus, downloads, uploads | Exhaustively testing every validation permutation |
| Visual regression | Layout, styling, responsive composition, theme drift | Functional correctness without stable visual fixtures |

Prefer a small number of tests at each appropriate level over duplicating the same assertion across
the entire pyramid.

## Query Like a User

Prefer queries based on accessible roles, names, labels, and visible text. These align tests with
the interface contract and expose accessibility regressions.

```js
const save = screen.getByRole('button', { name: 'Save changes' });
await user.click(save);
expect(screen.getByRole('status')).toHaveTextContent('Changes saved');
```

Use test IDs only when the element has no meaningful accessible or semantic identity. Do not query
by framework internals, generated class names, or DOM position.

## Test Behavior and State Transitions

Cover:

- Initial, loading, loaded, empty, partial, error, retry, and offline states as applicable
- Keyboard and pointer activation
- Focus placement and restoration after dialogs, navigation, and dynamic updates
- Validation timing, error association, submission, and preserved input
- Permission and disabled states
- Rapid repeated input, cancellation, stale responses, and race conditions
- Long content, narrow containers, zoom-sensitive layouts, and supported themes

Use `ui-hardening` to identify the complete production state inventory before selecting the
highest-value automated cases.

## Browser Test Workflow

1. Start from a stable URL or explicit setup state.
2. Interact through visible controls rather than invoking application internals.
3. Wait for observable conditions, not arbitrary timeouts.
4. Assert the user-visible result and important side effects.
5. Capture traces, screenshots, console errors, and network failures when diagnosing.
6. Keep test data isolated so parallel runs cannot contaminate each other.
7. Clean up only data the test owns.

Do not use fixed sleeps to repair timing failures. Identify the event, request, render, or state the
test should wait for.

## Responsive and Cross-Browser Coverage

- Test representative layout breakpoints plus the narrowest supported container.
- Include touch/coarse-pointer behavior when it differs from desktop interaction.
- Run critical journeys in every browser engine the project officially supports.
- Keep the full matrix focused; run broader combinations on scheduled or release builds if cost is
  high.
- Verify mobile browser behavior that emulation cannot reproduce on a real device when risk warrants
  it.

## Visual Regression

- Stabilize fonts, animations, data, time, random values, and viewport before capture.
- Capture components or bounded surfaces when a full page creates unnecessary noise.
- Use thresholds to absorb rendering noise, not to hide meaningful differences.
- Review changed images; do not automatically update baselines merely to make CI pass.
- Pair visual checks with semantic or behavioral assertions for critical functionality.
- Include important themes, responsive states, and error states rather than only the default page.

## Accessibility Testing

Automated accessibility checks are useful but incomplete. Combine them with:

- Role/name assertions
- Keyboard-only task completion
- Visible focus verification
- Focus order, movement, and restoration
- Zoom/reflow and large-text checks
- Manual screen-reader testing for consequential or custom interaction patterns

Use `wcag` for remediation details and `qa` for a broad pre-release audit.

## Flaky Test Diagnosis

Classify the failure before changing the test:

- **Synchronization:** waiting for time instead of state
- **Isolation:** shared accounts, data, storage, ports, or order dependence
- **Environment:** fonts, locale, timezone, browser, animation, or network variance
- **Selector:** tied to layout or implementation details
- **Product race:** stale requests, duplicate actions, or nondeterministic application behavior

Reproduce with tracing and repeat mode. Fix product races when the test reveals a real race; do not
paper them over with retries. Use retries only as a bounded signal while the cause is investigated.

## What Not to Test

- Framework behavior the framework already guarantees
- Private methods, internal state shapes, or implementation-only events
- Every visual permutation through E2E tests
- Third-party internals beyond the integration contract you rely on
- Snapshot files so broad that reviewers cannot understand changes

## Project Context

Check AGENTS.md or local skill overlays for:

- Test runner, browser automation tool, component test utilities, and commands
- Supported browsers, devices, viewports, locales, and themes
- Stable test-data setup and cleanup mechanisms
- Authentication helpers and prohibited production integrations
- CI parallelism, artifact retention, retry, and quarantine policies
- Existing visual-baseline ownership and review process
