# Adding Skills

## Guidelines

### Universality Test
Ask: "Is this skill useful across multiple projects?" If the logic is specific to one domain or repository, it belongs in the project. If it solves a common problem (e.g., git operations, generic API calls), it is a candidate for the global library.

### Strategy: Deferred vs Active vs Project-specific
- **Active**: High-utility, well-tested skills ready for broad use.
- **Deferred**: Ideas or partially implemented skills that need more refinement before becoming active.
- **Project-specific**: Highly customized skills that live only within a target project's repository.

## Custom Skills (Personal, Non-Universal)

Skills that don't belong in this repo because they are project-specific or personal can live in
`~/.agents/skills/custom/`. This path is the convention for user-local skills:

- Not tracked by agent-config or validate.sh
- Not distributed to other projects via update.sh
- Use the same SKILL.md format as universal skills
- Agents that read from `~/.agents/skills/` will also find them here if configured

This is the right place for skills you use across your own machines but that aren't general enough
to contribute back. Create the directory manually:

```bash
mkdir -p ~/.agents/skills/custom
```

validate.sh does not scan `~/.agents/skills/custom/` and will never report issues there.
