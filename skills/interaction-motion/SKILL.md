---
name: interaction-motion
category: Frontend
tags: [motion, animation, interaction, transitions, microinteractions, reduced-motion, performance]
updated: 2026-07-16
triggers: ["animate this","add a transition","microinteraction","motion feels off","page transition","scroll animation","spring or easing","make this interaction feel better"]
description: >
  Act as the interaction and motion design advisor for web interfaces. Use when designing,
  implementing, reviewing, or debugging transitions, microinteractions, gesture feedback, page or
  route changes, scroll-linked effects, and animation systems. Trigger on phrases like "animate
  this", "add a transition", "microinteraction", "motion feels off", "page transition", "scroll
  animation", "spring or easing", or "make this interaction feel better". Cover reduced motion and
  animation performance; use `performance` for broader loading and Core Web Vitals work.
---

# Interaction and Motion Advisor

Use motion to explain change, preserve context, confirm input, and create appropriate character.
Animation is part of interaction design—not decoration applied after the interface works.

## Start With the Interaction

Before choosing a duration or library, identify:

1. What changed?
2. What does the user need to notice or understand?
3. Is motion the clearest feedback, or would immediate state change be better?
4. Can the animation be interrupted or reversed safely?
5. What should happen when reduced motion is requested?

If the animation has no job, remove it.

## Motion Vocabulary

Use consistent categories across a product:

- **Feedback:** press, hover, selection, success, rejection
- **Transition:** opening, closing, entering, leaving, navigating
- **Continuity:** shared position, reordering, resizing, state morphing
- **Orientation:** showing where content came from or where it went
- **Attention:** drawing notice to a consequential change
- **Ambient:** non-essential atmosphere used with restraint

Define shared tokens for durations and easings. Avoid independently inventing motion for every
component.

## Choose Timing by Distance and Consequence

- Immediate feedback should begin without perceptible delay.
- Small local changes should generally be faster than large spatial transitions.
- Entrances may ease out; exits may be slightly faster and ease in.
- Use springs for interruptible, spatial, or gesture-driven movement where velocity matters.
- Use easing curves for deterministic opacity, color, and simple state transitions.
- Stagger only when it clarifies grouping or sequence. Keep delays short and cap the total wait.

Do not encode meaning in exact millisecond rules. Render and tune against the actual distance,
content, input method, and device.

## Implementation Priorities

1. Prefer CSS transitions and keyframes for simple state-driven effects.
2. Use the Web Animations API when runtime control, cancellation, or sequencing is needed.
3. Use the View Transitions API when preserving visual continuity across DOM or route changes and
   the project's browser support permits it.
4. Add a library only when gesture physics, orchestration, SVG morphing, or framework lifecycle
   integration genuinely requires it.

Keep animation state derived from application state. Ensure cleanup occurs when components unmount
or animations are replaced.

## Performance

- Prefer `transform` and `opacity` for frequently animated properties.
- Avoid repeated layout reads and writes in the same frame.
- Do not animate large blur filters, shadows, masks, or fixed backgrounds without profiling.
- Use `requestAnimationFrame` for frame-synchronized JavaScript work.
- Apply `will-change` narrowly and remove it when no longer needed.
- Test on a representative low-powered device, not only a desktop development machine.
- Use DevTools performance traces to verify dropped frames and layout work.

Use `performance` when the problem extends beyond motion into loading, rendering, bundles, or Core
Web Vitals.

## Reduced Motion

Reduced motion is an alternate interaction design, not a global instruction to set every duration
to zero.

```css
@media (prefers-reduced-motion: reduce) {
  .panel {
    transition: opacity 120ms linear;
    transform: none;
  }
}
```

- Remove parallax, large spatial travel, autoplay, looping, and simulated camera movement.
- Preserve essential feedback through instant changes, short fades, or other non-spatial cues.
- Ensure reduced-motion rules cover JavaScript and library animations as well as CSS.
- Never make content or actions depend on an animation completing.

## Common Interaction Patterns

### Buttons and controls

Provide immediate pressed or selected feedback. Avoid scale effects that shift nearby layout or
make controls difficult to target.

### Menus, popovers, and dialogs

Animate from a spatially plausible origin without delaying focus management. Closing must remain
available during entrance motion. Restore focus based on interaction state, not animation events.

### Lists and reordering

Preserve object continuity when items move. Avoid animating every update in high-frequency feeds.

### Page and route transitions

Keep navigation semantics and history correct. Never hold the next page hostage to a decorative
exit animation. Account for interrupted navigation, loading, back/forward, and reduced motion.

### Scroll-linked effects

Use only when scroll position genuinely maps to progress or storytelling. Keep content readable
without the effect, avoid scroll hijacking, and test keyboard, touch, and reduced-motion behavior.

## Review Workflow

1. Record the interaction at normal and reduced-motion settings.
2. Verify state correctness with rapid repeated input and interruption.
3. Check keyboard and touch behavior.
4. Profile for layout, paint, long tasks, and dropped frames.
5. Review consistency with the product's other transitions.
6. Remove motion that adds latency, hides state, or competes for attention.

## Project Context

Check AGENTS.md or local skill overlays for:

- Existing duration, easing, and spring tokens
- Framework lifecycle and routing behavior
- Animation libraries already approved in the project
- Browser support for View Transitions and other platform APIs
- Reduced-motion policy and accessibility requirements
- Performance budgets and representative test devices
