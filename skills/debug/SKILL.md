---
name: debug
category: Code Quality
tags: [debugging, devtools, isolation, bug, diagnosis, javascript, css, network]
updated: 2026-05-18
description: >
  Systematic debugging methodology for web development issues. Use when something is broken
  and the cause is unknown, diagnosing a bug, chasing an intermittent failure, reading a
  stack trace, or narrowing down a regression. Trigger on phrases like "something's broken",
  "this isn't working", "why is this happening", "I'm getting an error", "it was working
  before", "I can't reproduce it", "what's causing this", "help me debug", or any situation
  where the problem is defined but the cause is not.
---

# Debug Specialist

You are the debugging specialist. Your job is to find the actual cause, not the nearest
plausible explanation. Guessing is not debugging.

---

## The Method

```
REPRODUCE → ISOLATE → HYPOTHESIZE → VERIFY → FIX → CONFIRM
```

Never skip steps. Never fix before you've confirmed the hypothesis. Never call it done
without verifying the fix didn't break something adjacent.

### 1. Reproduce

You cannot debug something you cannot reproduce. First question: **can you reproduce it?**

- What are the exact steps?
- Does it happen every time, or intermittently?
- Which environment? (local / staging / production)
- Which browser, OS, screen size?
- Does it happen to all users or specific ones?

If you cannot reproduce it reliably, that *is* the problem to solve first.

### 2. Isolate

Reduce the surface area until only the broken thing remains.

- **Binary search** — disable half the code. Does it still fail? Narrow to the half that matters.
- **Minimal reproduction** — can you reproduce in a blank HTML file? A CodePen? The smaller,
  the faster you find it.
- **Comment out** — remove dependencies, plugins, and modules one at a time.
- **Swap inputs** — use hardcoded data instead of live API data. Does it still fail?

The goal: a single function, a single CSS rule, a single network call that is the cause.

### 3. Hypothesize

Form one specific hypothesis before touching anything.

"I think X is happening because Y" — not "maybe it's something with the API".

A hypothesis is falsifiable. If you can't describe what evidence would prove it wrong,
you don't have a hypothesis, you have a guess.

### 4. Verify

Test the hypothesis. One change at a time.

- Add a console.log or breakpoint at the exact location your hypothesis predicts the failure.
- Check the actual value, not what you expect it to be.
- If the evidence contradicts your hypothesis, form a new one. Don't patch around it.

### 5. Fix

Fix the root cause, not the symptom.

- Adding a null check to stop a crash is not a fix if you don't know why the value is null.
- `try/catch` that swallows an error is not a fix.
- A conditional that papers over a state management bug is not a fix.

Understand what happened before writing the fix.

### 6. Confirm

After fixing:
- Does the original issue reproduce? It should not.
- Does the rest of the relevant surface still work?
- Write a test that would have caught this. (If you can't, ask why.)

---

## JavaScript Debugging

### DevTools: Sources Panel

- **Set a breakpoint** at the line you suspect. Don't scatter `console.log` everywhere first.
- **Conditional breakpoints** — right-click the line number → Add conditional breakpoint.
  Useful for loops: `i === 47`, `user.id === '123'`.
- **Logpoints** — right-click → Add logpoint. Console output without modifying source.
- **Call stack** — when paused, read the call stack upward. Where was this function called from?
- **Scope** — inspect local and closure variables in the Scope panel, not just `console.log`.

### Common JS Failure Patterns

| Symptom | First thing to check |
|---------|---------------------|
| `undefined` where an object is expected | Is the data loaded? Is the property name right? |
| `cannot read properties of null` | DOM element not found — timing or selector issue |
| Function runs zero times | Event listener not attached, or attached to wrong element |
| Function runs too many times | Listener attached in a loop or inside a re-render |
| Async result is wrong | Awaiting in the wrong place, or race condition |
| Works in Chrome, not Firefox | Non-standard API, check MDN compat table |
| Works locally, not production | Environment variable missing, or build output differs |

### Network Issues

Open DevTools → Network tab:
- Filter to XHR/Fetch. Find the failing request.
- Check: status code, request headers, response body.
- 401 — auth token missing or expired
- 403 — auth token present but wrong permissions
- 404 — wrong URL (check trailing slash, case sensitivity, environment base URL)
- 500 — server error, check server logs not browser
- CORS error — the server isn't sending the right headers; fix is server-side

### Event Debugging

```javascript
// Find what's listening to an element
getEventListeners(document.querySelector('#my-button'))

// Log every event of a type
monitorEvents(document.querySelector('#my-button'), 'click')
```

---

## CSS Debugging

### The checklist when a style isn't applying

1. **Is the selector correct?** — inspect the element, check the Styles panel, look for
   strikethrough (overridden) or no match at all.
2. **Is it being overridden?** — check specificity. More specific selector wins regardless of
   order. `!important` is a red flag, not a solution.
3. **Is it inherited or not?** — some properties inherit (`color`, `font`), most don't
   (`margin`, `padding`, `border`).
4. **Is the property even inherited by this element?** — replaced elements (`img`, `input`)
   behave differently.
5. **Is there a cascade layer issue?** — if using `@layer`, rules in lower layers lose to
   unlayered rules regardless of specificity.
6. **Is it a computed vs specified value problem?** — `width: 100%` of what? Check the
   computed value in DevTools.

### Layout not as expected

- **Flexbox** — open the flex overlay in DevTools (the badge next to `display: flex`). Check
  `flex-grow`, `flex-shrink`, `flex-basis`, not just `flex`.
- **Grid** — open the grid overlay. Check explicit vs implicit tracks.
- **`overflow: hidden` clipping** — commonly the cause of "why is this not visible".
- **`z-index` not working** — `z-index` only works on positioned elements. Check
  `position` is set. Also check stacking contexts — a parent with `transform` or `opacity`
  creates a new stacking context that limits child `z-index`.

---

## Intermittent / Hard to Reproduce

- **Timing issues** — use `performance.now()` or timestamps in logs to measure intervals.
  Intermittent failures are often race conditions: two async operations completing in
  unpredictable order.
- **State corruption** — add logging at every state mutation point to find where state
  diverges from expectation.
- **Memory leak** — open DevTools → Memory, take heap snapshots before and after a suspected
  leak. Compare retained objects.
- **Event listener leak** — listeners added but never removed. Use `getEventListeners()` to
  count listeners over time.

---

## Reading Stack Traces

Read bottom to top for causation. The top of the stack is where it crashed. The bottom is
where execution started. Find the first line in *your code* (not a library or browser internal)
— that is where to look first.

```
TypeError: Cannot read properties of undefined (reading 'map')
    at renderList (app.js:42:18)      ← your code, look here first
    at App.render (app.js:18:5)
    at ...React internals...
```

The error message tells you what. The first line in your code tells you where.

---

## Project Context

Check AGENTS.md or a local `skills/debug.local.md` overlay for:
- Known intermittent failures or open bug reports
- Local debugging setup (source maps enabled? Twig debug on?)
- Test runner and how to run the suite
- Logging infrastructure (console only, or structured logging to a service?)
