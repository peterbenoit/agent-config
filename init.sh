#!/bin/bash
# agent-config/init.sh
#
# Wire agent-config skills into a new project.
# Run from inside the project root you want to set up.
#
# Usage:
#   ~/GitHub/agent-config/init.sh
#   ~/GitHub/agent-config/init.sh --link    # symlink instead of copy (local dev only)
#   ~/GitHub/agent-config/init.sh --dry-run # preview what would happen

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
SKILLS_SRC="$AGENT_CONFIG_DIR/skills"
SKILLS_DEST="$PROJECT_DIR/skills"
AGENTS_FILE="$PROJECT_DIR/AGENTS.md"
LINK_MODE=false
DRY_RUN=false

# Parse flags
for arg in "$@"; do
  case $arg in
    --link) LINK_MODE=true ;;
    --dry-run) DRY_RUN=true ;;
  esac
done

# ── Helpers ──────────────────────────────────────────────────────────────────

log() { echo "  $1"; }
action() { echo "▸ $1"; }
warn() { echo "⚠ $1"; }
dry() { echo "  [dry-run] $1"; }

# ── Safety checks ─────────────────────────────────────────────────────────────

if [ "$PROJECT_DIR" = "$AGENT_CONFIG_DIR" ]; then
  warn "You're inside agent-config itself. Run this from your project root."
  exit 1
fi

if [ ! -d "$SKILLS_SRC" ]; then
  warn "Skills directory not found at $SKILLS_SRC"
  exit 1
fi

echo ""
echo "agent-config init"
echo "  source : $AGENT_CONFIG_DIR"
echo "  target : $PROJECT_DIR"
echo ""

# ── Skills ────────────────────────────────────────────────────────────────────

if [ -d "$SKILLS_DEST" ]; then
  warn "skills/ already exists in this project — skipping."
  warn "To update, remove skills/ and re-run, or copy individual skills manually."
else
  if [ "$LINK_MODE" = true ]; then
    action "Symlinking skills/ → $SKILLS_SRC"
    if [ "$DRY_RUN" = false ]; then
      ln -sf "$SKILLS_SRC" "$SKILLS_DEST"
      log "Linked. Note: symlinks break in CI and cloud agents."
    else
      dry "ln -sf $SKILLS_SRC $SKILLS_DEST"
    fi
  else
    action "Copying skills/ into project"
    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$SKILLS_DEST"
      [ -f "$SKILLS_SRC/README.md" ] && cp "$SKILLS_SRC/README.md" "$SKILLS_DEST/README.md"
      count=0
      for skill_dir in "$SKILLS_SRC"/*/; do
        skill_name=$(basename "$skill_dir")
        if [ -f "$skill_dir/SKILL.md" ]; then
          cp -r "$skill_dir" "$SKILLS_DEST/$skill_name"
          count=$((count + 1))
        fi
      done
      log "Copied $count skills."
    else
      count=0
      for skill_dir in "$SKILLS_SRC"/*/; do
        [ -f "$skill_dir/SKILL.md" ] && count=$((count + 1))
      done
      dry "Would create $SKILLS_DEST/"
      dry "Would copy $count skills (placeholders excluded)."
    fi
  fi
fi

# ── AGENTS.md ─────────────────────────────────────────────────────────────────

if [ -f "$AGENTS_FILE" ]; then
  warn "AGENTS.md already exists — skipping."
  warn "Add the following block manually if you want skills wired up:"
  echo ""
  echo "  ## Skills"
  echo "  Agent skills are in \`./skills/\`. Each subfolder has a SKILL.md."
  echo "  Read the relevant skill before starting any matching task."
  echo "  Add project-specific overlays as \`./skills/<name>.local.md\`."
  echo ""
else
  action "Creating starter AGENTS.md"
  if [ "$DRY_RUN" = false ]; then
    cat > "$AGENTS_FILE" << 'EOF'
# Project Name

Short description of what this project is and does.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

To add project-specific context to a universal skill, create a local overlay file:
`./skills/<name>.local.md` — the agent reads both; the local file wins on conflicts.
Do not edit the SKILL.md directly — it will be overwritten on updates.

## Context

If this project has a CONTEXT.md in the root, read it before starting any task.
It defines domain-specific terms, key system relationships, and decisions that should
not be silently reversed. AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
# Add your build commands here
```

## Architecture

<!-- Describe the structure of this project: what calls what, where the source of truth
     lives for each concern, and any non-obvious dependencies. -->

## What Not to Do

<!-- Add project-specific guardrails here: patterns that look like improvements but aren't,
     decisions that were made deliberately, and anything that should never be changed silently. -->
EOF
    log "Created AGENTS.md — fill in the project-specific sections."
  else
    dry "Would create AGENTS.md with starter template."
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Next steps:"
echo "  1. Fill in AGENTS.md — build commands, architecture, guardrails"
echo "  2. Add project-specific skill overlays to skills/ as needed"
echo "  3. Commit both to the project repo"
echo ""
