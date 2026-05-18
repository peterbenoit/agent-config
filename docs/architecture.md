# Architecture Decisions

## Description: Block Scalar vs Plain Scalar
We use `description: >` (folded block scalar) instead of plain scalars to ensure consistent formatting and readability. Plain scalars can be brittle with special characters and line breaks, whereas block scalars handle multi-line descriptions cleanly and preserve intent without requiring complex escaping.

## .local.md Overlay Pattern
The `.local.md` overlay pattern is preferred over a dedicated overrides directory to keep project-specific modifications alongside the base definition. This co-location makes it easier for developers to see what is being overridden without navigating away, reduces directory sprawl, and simplifies the merging logic.

## validate.sh: Bash vs Test Framework
`validate.sh` is written in Bash rather than a full-fledged test framework (like Jest or Pytest) to minimize dependencies. Bash is ubiquitous in CI/CD environments and provides sufficient power for the linting and schema validation tasks required without the overhead of maintaining a language-specific toolchain.

## Skill Copying vs Symlinking
Skills are copied into projects rather than just being symlinked to ensure project portability and stability. Copying prevents a project from breaking if the global skill library changes and allows projects to be archived or moved as self-contained units with their specific skill versions intact.
