---
name: tdd
category: Code Quality
tags: [tdd, testing, red-green-refactor, test-first, javascript]
updated: 2026-05-18
description: >
  Test-driven development with a strict red-green-refactor loop. Use when building features or
  fixing bugs using TDD, mentions "red-green-refactor", wants test-first development, or asks to
  write tests before implementation. Applies to any JS/TS codebase. Trigger on phrases like
  "use TDD", "write the test first", "red-green-refactor", "test-driven", "failing test first",
  or "don't write code until there's a test".
---

# TDD — Red-Green-Refactor

Core principle: Tests verify behavior through public interfaces, not implementation details.
Code can change entirely; tests shouldn't.

## What Good Tests Look Like

Good tests are integration-style — they exercise real code paths through public APIs. They describe
what the system does, not how it does it. A good test reads like a specification:
"user can init with custom breakpoints" tells you exactly what capability exists. These tests
survive refactors because they don't care about internal structure.

Bad tests are coupled to implementation. They mock internal collaborators, test private methods,
or verify through external means rather than through the interface the user actually calls.

## The Loop

RED → GREEN → REFACTOR — one vertical slice at a time.

```
RED:    Write one failing test for the next unit of behavior
GREEN:  Write the minimum code to make it pass — no more
REFACTOR: Clean up without changing behavior, re-run to confirm still green
REPEAT
```

## NEVER Horizontal Slice

WRONG:
```
RED:   test1, test2, test3, test4, test5
GREEN: impl1, impl2, impl3, impl4, impl5
```

RIGHT:
```
RED→GREEN: test1 → impl1
RED→GREEN: test2 → impl2
RED→GREEN: test3 → impl3
```

Horizontal slicing (write all tests first, then all implementation) leads to:
- Testing the shape of things rather than behavior
- Tests that pass when behavior breaks and fail when behavior is fine
- Committing to test structure before understanding the implementation

## Refactor Rules

- Only refactor on GREEN — never on RED
- Run tests after every refactor step, not after a batch
- If you touch existing passing tests during a refactor, stop and re-examine

## What to Test

- Public API surface only (exported functions, class methods, event interfaces)
- Edge cases and error paths, not just the happy path
- Behavior contracts: "given X input, produces Y output" — not internal state

## What Not to Test

- Private functions or internal module structure
- Implementation choices that could change (internal data shapes, intermediate variables)
- Things already tested by the runtime or library you're using

---

## Project Context

Check AGENTS.md or local skill overlays for:
- The test runner for this project (Jest, Vitest, Mocha, etc.) and the command to run tests
- File naming convention for test files (`*.test.ts`, `*.spec.ts`, `__tests__/`, etc.)
- Whether this project uses test doubles (mocks, stubs, fakes) and any project-level conventions
  around them
- Any directories or files explicitly excluded from test coverage
