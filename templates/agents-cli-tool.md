# AGENTS.md — <!-- Tool name --> CLI

<!-- One sentence: what this CLI tool does and who uses it. -->

---

## What This Is

<!-- Describe the CLI tool: what problem it solves, what the primary interface is,
and whether it's meant for interactive use, automation, or both. -->

---

## Commands

<!-- List the main commands and subcommands.

| Command | Description |
|---------|-------------|
| `tool-name <command>` | ... |
| `tool-name init` | ... |
| `tool-name run [options]` | ... |
-->

---

## Architecture

```
<!-- Describe the code structure. Example:
src/
  cli.js          # Entry point — argument parsing and command dispatch
  commands/       # One file per top-level command
  lib/            # Shared utilities
  config.js       # Configuration loading
```

**Entry point:** <!-- bin/cli.js or src/index.js -->
**Config file:** <!-- .toolname.json / .toolnamerc / package.json "tool" field -->

---

## Local Development

```bash
# Install dependencies
npm install

# Link the binary locally for testing
npm link

# Run in development
node src/cli.js <command>

# Run tests
npm test
```

---

## Publishing

```bash
# Build (if applicable)
npm run build

# Verify what will be published
npm pack --dry-run

# Publish
npm publish --access public
```

Package name: `<!-- @scope/tool-name -->`

---

## Configuration

<!-- Describe how users configure the tool.
Config file format, precedence (flags > env vars > config file > defaults), and any schema. -->

---

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| <!-- `TOOL_API_KEY` --> | <!-- Yes/No --> | <!-- What it is --> |

---

## Output Formats

<!-- Describe the output modes: human-readable vs machine-readable (--json flag), exit codes. -->

**Exit codes:**

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | General error |
| <!-- `2` --> | <!-- e.g., Configuration error --> |

---

## Testing

```bash
npm test
```

<!-- Describe the test strategy: unit tests for individual commands, integration tests
with fixture inputs, snapshot tests for output format. -->

---

## Hard Rules

- All user input must be validated before use — never pass unsanitized values to shell commands
- Never write credentials or secrets to stdout or log files
- Every command must have a `--help` flag that works even if configuration is missing
- Destructive operations must have a `--dry-run` flag and require explicit confirmation without it
- Exit codes must be consistent: 0 for success, non-zero for any failure

## Skills

Agent skills are in `./skills/`. **Recommended for CLI tools:** `security`, `tdd`, `qa`, `npm-publish`, `git-guardrails`

---

## Known Issues / Gotchas

<!-- List anything non-obvious: OS-specific behavior, terminal compatibility, known edge cases. -->
