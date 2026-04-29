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
      cp -r "$SKILLS_SRC" "$SKILLS_DEST"
      log "Copied $(ls "$SKILLS_DEST" | wc -l | tr -d ' ') skills."
    else
      dry "cp -r $SKILLS_SRC $SKILLS_DEST"
      dry "Would copy $(ls "$SKILLS_SRC" | wc -l | tr -d ' ') skills."
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
  echo "  Add project-specific overlays as \`./skills/<name>/SKILL.md\`."
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

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>/SKILL.md` — the agent reads both; the local file wins on conflicts.

## Build & Dev

```sh
# Add your build commands here
```

## Architecture

<!-- Describe the structure of this project -->

## What Not to Do

<!-- Add project-specific guardrails here -->
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
