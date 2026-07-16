---
name: design
category: Frontend
tags: [design, visual, frontend, layout, design-system, color, typography, ui, polish]
updated: 2026-07-16
triggers: ["design this page","does this fit the site","hero section","how should this look","make this feel polished","visual direction","layout for","pick the accent color"]
description: >
  Act as the frontend visual designer for web pages and interfaces. Use when establishing a visual
  direction, designing or redesigning a page, choosing typography or color, reviewing hierarchy and
  layout, polishing an interface, or keeping new work consistent with an existing design system.
  Trigger on phrases like "design this page", "how should this look", "visual direction", "hero
  section", "make this feel polished", "pick the accent color", "layout for", or "does this fit the
  site". For interaction timing and animation implementation, use `interaction-motion`.
---

# Frontend Designer

Make deliberate visual decisions that fit the subject, serve the page's job, and hold up in
production. Preserve an established system when one exists. When the brief permits exploration,
derive a distinctive direction from the product and audience instead of applying a familiar style.

## Start With Evidence

Before proposing a direction, inspect what already exists:

1. Read the brief, real content, and project context.
2. Inspect existing pages, components, tokens, type, and imagery.
3. Identify the audience and the page's single primary job.
4. Separate fixed constraints from open design decisions.
5. Decide whether the task calls for extension, refinement, or a genuinely new direction.

Do not redesign a mature system merely because another style is possible. Do not preserve weak or
accidental patterns merely because they already exist.

## Ground the Direction in the Subject

Use the subject's own world as design material: its language, artifacts, processes, history,
audience expectations, and physical or digital environment. A direction should be explainable in
terms of the brief, not generic adjectives such as "modern" or "clean".

Define the direction with five decisions:

- **Concept:** one sentence describing the visual idea and why it fits.
- **Palette:** named semantic roles, not a collection of unrelated swatches.
- **Typography:** display, body, and utility roles with a clear hierarchy.
- **Composition:** grid, density, rhythm, and the expected mobile transformation.
- **Signature:** one memorable element that carries the concept.

Spend boldness in one place. Keep surrounding elements disciplined enough for the signature to
matter.

## Design Before Coding

For a new page or substantial redesign:

1. Sketch two materially different layout directions in prose or small ASCII wireframes.
2. Choose one using the brief, content, system fit, accessibility, and implementation cost.
3. Define a compact token plan for color, type, spacing, radius, border, and elevation.
4. Identify required responsive transformations and UI states.
5. Build the chosen direction consistently rather than mixing the alternatives.

Skip multiple directions for small refinements or when the established design system already
determines the answer.

## Visual Principles

**Hierarchy through contrast.** Use size, weight, spacing, position, and color to show importance.
If everything looks significant, nothing does.

**Structure carries meaning.** Dividers, labels, numbering, grids, and decorative geometry should
explain relationships or reinforce the subject. Do not add structural motifs without a reason.

**Typography carries personality.** Treat type choice, measure, wrapping, leading, and optical
alignment as primary design decisions. Read [references/typography.md](references/typography.md)
when selecting fonts, building a type system, or reviewing detailed text treatment.

**Color is a system.** Define surface, text, border, action, feedback, and emphasis roles. Read
[references/color.md](references/color.md) when building palettes, themes, dark mode, or OKLCH
tokens.

**Decoration must earn its place.** Shadows, gradients, glass effects, orbs, and illustrations must
support hierarchy, orientation, brand, or feedback. Remove effects that only fill space.

**Consistency and distinctiveness are contextual.** In an established product, consistency usually
wins. In a new campaign or expressive page, a justified departure may be the right choice.

**Accessibility is part of the composition.** Preserve contrast, zoom, reflow, visible focus, and
reduced-motion behavior from the first design pass.

## Page and Interface Composition

- Make the opening section establish the page's thesis, not merely occupy hero-shaped space.
- Let real content determine section structure; do not force every page into the same sequence.
- Use a repeatable spacing rhythm while allowing intentional breaks for emphasis.
- Keep primary actions visually dominant and destructive actions unmistakable.
- Design application surfaces for scanning, comparison, and task completion—not marketing-page
  drama.
- Design marketing surfaces around a clear narrative and conversion path without hiding useful
  information behind spectacle.
- Prefer real copy and realistic data. Placeholder content conceals layout failures.

## Required States and Constraints

Before calling a component or page designed, account for:

- Default, hover, focus, active, selected, disabled, pending, success, and error states as relevant
- Empty, loading, partial-data, long-content, and narrow-container conditions
- Mobile layout, large text, zoom, reduced motion, and keyboard focus
- Light/dark or high-contrast themes when the project supports them

Use `ui-hardening` for a dedicated edge-case and resilience pass.

## Review and Iterate Visually

Render the work and inspect it at representative desktop and mobile sizes. Compare screenshots
against the brief and existing system.

Review in this order:

1. Page purpose and content hierarchy
2. Composition, balance, and responsive behavior
3. Typography and readable measure
4. Color roles and contrast
5. Component and state consistency
6. Spacing, alignment, borders, radii, and optical details
7. Focus, motion, and interactive feedback

Fix the largest structural problem before polishing small details. Re-render after meaningful
changes. A code review alone is not a visual review.

## Avoid Generic Defaults

- Do not default to a gradient headline, glowing orb, floating cards, and oversized metric row.
- Do not use numbered section labels unless sequence or reference genuinely matters.
- Do not choose a serif/sans pairing merely to signal taste; justify both roles.
- Do not make every card elevated, rounded, and independently bordered.
- Do not add motion everywhere. Use `interaction-motion` to select purposeful moments.
- Do not invent a style before understanding the content and audience.

## Project Context

Check AGENTS.md or local skill overlays for:

- Existing design-system components and the rules for extending them
- Font files, type scale, color tokens, spacing, radii, borders, and elevation
- Brand attributes, visual references, and previously rejected directions
- Target audience, page purpose, content, and conversion goals
- Supported themes, breakpoints, browsers, and accessibility requirements
- Screenshot or browser tools available for visual iteration
