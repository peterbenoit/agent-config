#!/bin/bash
# agent-config/init.sh
#
# Wire agent-config skills into a new project.
# Run from inside the project root you want to set up.
#
# Usage:
#   ~/GitHub/agent-config/init.sh
#   ~/GitHub/agent-config/init.sh --link             # symlink instead of copy (local dev only)
#   ~/GitHub/agent-config/init.sh --dry-run           # preview what would happen
#   ~/GitHub/agent-config/init.sh --select seo,tdd    # install only named skills
#   ~/GitHub/agent-config/init.sh --template federal-app   # select AGENTS.md starter
#   ~/GitHub/agent-config/init.sh --with-hooks        # also install block-dangerous-git.sh
#   ~/GitHub/agent-config/init.sh --with-instructions # also install .instructions.md files

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
SKILLS_SRC="$AGENT_CONFIG_DIR/skills"
SKILLS_DEST="$PROJECT_DIR/skills"
AGENTS_FILE="$PROJECT_DIR/AGENTS.md"
LINK_MODE=false
DRY_RUN=false
SELECT=""       # comma-separated skill names, empty = all
TEMPLATE=""     # agents-<name>.md, empty = agents-default.md
WITH_HOOKS=false
WITH_INSTRUCTIONS=false

# Parse flags
while [ $# -gt 0 ]; do
  case "$1" in
    --link) LINK_MODE=true ;;
    --dry-run) DRY_RUN=true ;;
    --with-hooks) WITH_HOOKS=true ;;
    --with-instructions) WITH_INSTRUCTIONS=true ;;
    --select=*) SELECT="${1#--select=}" ;;
    --select) SELECT="$2"; shift ;;
    --template=*) TEMPLATE="${1#--template=}" ;;
    --template) TEMPLATE="$2"; shift ;;
    --help|-h)
      echo "Usage: ~/GitHub/agent-config/init.sh [options]"
      echo ""
      echo "Options:"
      echo "  --select NAME,...   Install only named skills (comma-separated)"
      echo "  --template NAME     Use agents-NAME.md as the AGENTS.md starter"
      echo "  --with-hooks        Also install block-dangerous-git.sh"
      echo "  --with-instructions Also install .instructions.md files"
      echo "  --link              Symlink skills/ instead of copying (local dev only)"
      echo "  --dry-run           Preview changes without writing files"
      exit 0
      ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
  shift
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

# ── Detect existing agent-config init ─────────────────────────────────────────

EXISTING_DOTFILE="$PROJECT_DIR/.agent-config"
if [ -f "$EXISTING_DOTFILE" ]; then
  existing_source=$(grep "^source=" "$EXISTING_DOTFILE" | cut -d= -f2-)
  existing_date=$(grep "^init_date=" "$EXISTING_DOTFILE" | cut -d= -f2-)
  if [ "$existing_source" != "$AGENT_CONFIG_DIR" ]; then
    warn "This project was initialized from a different agent-config: $existing_source"
    warn "Current source: $AGENT_CONFIG_DIR"
    warn "Run update.sh to sync skills, or remove .agent-config and re-run init.sh."
  else
    warn "This project was already initialized on $existing_date."
    warn "Run update.sh to pull in new or updated skills."
    warn "Re-running init.sh will skip existing files."
  fi
  echo ""
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
          # --select filter: skip if not in the list
          if [ -n "$SELECT" ]; then
            if ! echo ",$SELECT," | grep -q ",$skill_name,"; then
              continue
            fi
          fi
          cp -r "$skill_dir" "$SKILLS_DEST/$skill_name"
          count=$((count + 1))
        fi
      done
      log "Copied $count skills."
    else
      count=0
      for skill_dir in "$SKILLS_SRC"/*/; do
        skill_name=$(basename "$skill_dir")
        if [ -f "$skill_dir/SKILL.md" ]; then
          if [ -n "$SELECT" ]; then
            echo ",$SELECT," | grep -q ",$skill_name," || continue
          fi
          count=$((count + 1))
        fi
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
  # resolve template file
  if [ -n "$TEMPLATE" ]; then
    TEMPLATE_FILE="$AGENT_CONFIG_DIR/templates/agents-${TEMPLATE}.md"
    if [ ! -f "$TEMPLATE_FILE" ]; then
      warn "Template 'agents-${TEMPLATE}.md' not found in templates/. Available templates:"
      ls "$AGENT_CONFIG_DIR/templates/"agents-*.md 2>/dev/null | sed "s|.*agents-||;s|\.md||" | while read -r t; do echo "    $t"; done
      warn "Falling back to agents-default.md"
      TEMPLATE_FILE="$AGENT_CONFIG_DIR/templates/agents-default.md"
    fi
  else
    TEMPLATE_FILE="$AGENT_CONFIG_DIR/templates/agents-default.md"
  fi

  if [ "$DRY_RUN" = false ]; then
    if [ -f "$TEMPLATE_FILE" ]; then
      cp "$TEMPLATE_FILE" "$AGENTS_FILE"
      log "Created AGENTS.md from $(basename "$TEMPLATE_FILE") — fill in the placeholders."
    else
      # Fallback to heredoc if template missing
      cat > "$AGENTS_FILE" << 'EOF'
# Project Name

Short description of what this project is and does.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

**Recommended for most projects:** `security`, `git-guardrails`, `qa`, `tdd`

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>.local.md` — the agent reads both; the local file wins on conflicts.
Do not edit `SKILL.md` directly — it will be overwritten on updates.

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
    fi
  else
    dry "Would create AGENTS.md from $(basename "$TEMPLATE_FILE")."
  fi
fi

# ── Hooks (--with-hooks) ──────────────────────────────────────────────────────

if [ "$WITH_HOOKS" = true ]; then
  HOOKS_DEST="$PROJECT_DIR/hooks"
  HOOK_SCRIPT="block-dangerous-git.sh"
  action "Installing hooks"
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$HOOKS_DEST"
    cp "$AGENT_CONFIG_DIR/hooks/$HOOK_SCRIPT" "$HOOKS_DEST/$HOOK_SCRIPT"
    chmod +x "$HOOKS_DEST/$HOOK_SCRIPT"
    log "Copied hooks/$HOOK_SCRIPT"
    # Wire .claude/settings.json
    CLAUDE_DIR="$PROJECT_DIR/.claude"
    SETTINGS="$CLAUDE_DIR/settings.json"
    mkdir -p "$CLAUDE_DIR"
    if [ ! -f "$SETTINGS" ]; then
      cat > "$SETTINGS" << 'SETTINGS_EOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS_EOF
      log "Created .claude/settings.json with hook config"
    else
      warn ".claude/settings.json already exists — add hook config manually (see hooks/README.md)"
    fi
  else
    dry "Would copy hooks/block-dangerous-git.sh and create .claude/settings.json"
  fi
fi

# ── Instructions (--with-instructions) ────────────────────────────────────────

if [ "$WITH_INSTRUCTIONS" = true ]; then
  INSTR_DEST="$PROJECT_DIR/.github/instructions"
  action "Installing instructions"
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$INSTR_DEST"
    count=0
    for f in "$AGENT_CONFIG_DIR/instructions/"*.instructions.md; do
      [ -f "$f" ] || continue
      cp "$f" "$INSTR_DEST/$(basename "$f")"
      count=$((count + 1))
    done
    log "Installed $count instruction files to .github/instructions/"
  else
    dry "Would copy instructions/*.instructions.md to .github/instructions/"
  fi
fi

# ── .agent-config dotfile ─────────────────────────────────────────────────────

DOTFILE="$PROJECT_DIR/.agent-config"
INIT_DATE=$(date +%Y-%m-%d)
SKILL_LIST=$(ls "$SKILLS_SRC"/ | grep -v '^\.' | tr '\n' ',' | sed 's/,$//')

if [ -f "$DOTFILE" ]; then
  log ".agent-config already exists — skipping (re-run update.sh to refresh)"
else
  if [ "$DRY_RUN" = false ]; then
    cat > "$DOTFILE" << EOF
# agent-config init record — do not edit manually
source=$AGENT_CONFIG_DIR
init_date=$INIT_DATE
skills=$SKILL_LIST
EOF
    log "Created .agent-config (tracks source path and init date)"
  else
    dry "Would create .agent-config with source=$AGENT_CONFIG_DIR"
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Done. Next steps:"
echo "  1. Fill in AGENTS.md — build commands, architecture, guardrails"
echo "  2. Add skill overlays as ./skills/<name>.local.md for project-specific context"
echo "  3. Optionally copy hooks/, prompts/, or instructions/ assets from agent-config"
echo "  4. Commit to the project repo"
echo ""
