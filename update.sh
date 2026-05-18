#!/bin/bash
# agent-config/update.sh
#
# Pull skill updates from agent-config into an already-initialized project.
# Run from inside the project root.
#
# Usage:
#   ~/GitHub/agent-config/update.sh              # add new skills + update unmodified ones
#   ~/GitHub/agent-config/update.sh --dry-run    # preview what would change
#   ~/GitHub/agent-config/update.sh --force      # update all skills, even locally modified ones
#                                                # WARNING: --force overwrites local overlays

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
SKILLS_SRC="$AGENT_CONFIG_DIR/skills"
SKILLS_DEST="$PROJECT_DIR/skills"
DRY_RUN=false
FORCE=false
WITH_HOOKS=false
WITH_INSTRUCTIONS=false

# Parse flags
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --force) FORCE=true ;;
    --with-hooks) WITH_HOOKS=true ;;
    --with-instructions) WITH_INSTRUCTIONS=true ;;
    --help|-h)
      echo "Usage: ~/GitHub/agent-config/update.sh [options]"
      echo ""
      echo "Options:"
      echo "  --with-hooks        Also update hooks/ in this project"
      echo "  --with-instructions Also update .github/instructions/ in this project"
      echo "  --force             Overwrite locally modified files"
      echo "  --dry-run           Preview changes without writing files"
      exit 0
      ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
  shift
done

# ── Helpers ──────────────────────────────────────────────────────────────────

log()    { echo "  $1"; }
added()  { echo "  + $1"; }
updated(){ echo "  ↑ $1"; }
skipped(){ echo "  ~ $1"; }
warn()   { echo "⚠ $1"; }
dry()    { echo "  [dry-run] $1"; }

# ── Safety checks ─────────────────────────────────────────────────────────────

if [ "$PROJECT_DIR" = "$AGENT_CONFIG_DIR" ]; then
  warn "You're inside agent-config itself. Run this from your project root."
  exit 1
fi

if [ ! -d "$SKILLS_DEST" ]; then
  warn "No skills/ directory found. Run init.sh first to set up this project."
  exit 1
fi

if [ -L "$SKILLS_DEST" ]; then
  warn "skills/ is a symlink to agent-config — it's always current. Nothing to update."
  exit 0
fi

if [ "$FORCE" = true ]; then
  warn "--force is set. Locally modified SKILL.md base files and skills/README.md will be overwritten."
  warn "Local overlays (*.local.md) are not touched — they are never managed by this script."
  warn "If you have edited base SKILL.md files directly, press Ctrl-C now and update manually."
  echo ""
fi

echo ""
echo "agent-config update"
echo "  source : $AGENT_CONFIG_DIR"
echo "  target : $PROJECT_DIR"
[ "$FORCE" = true ] && echo "  mode   : force (overwrites local changes)"
echo ""

# ── Global symlink health ─────────────────────────────────────────────────────

echo "Global symlinks:"
symlink_ok=true
for target in ~/.agents/skills ~/.claude/skills ~/.codex/skills; do
  if [ ! -L "$target" ]; then
    warn "Missing symlink: $target"
    warn "  Fix: ln -s $SKILLS_SRC $target"
    symlink_ok=false
  else
    log "✓ $target"
  fi
done
[ "$symlink_ok" = false ] && echo ""

echo ""

count_added=0
count_updated=0
count_current=0
count_skipped=0
skipped_names=()

# ── Sync skills ───────────────────────────────────────────────────────────────

for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name=$(basename "$skill_dir")
  src_skill="$skill_dir/SKILL.md"
  dest_dir="$SKILLS_DEST/$skill_name"
  dest_skill="$dest_dir/SKILL.md"

  # Skip placeholder dirs (no SKILL.md in source)
  [ -f "$src_skill" ] || continue

  if [ ! -d "$dest_dir" ]; then
    # ── New skill: project doesn't have it yet ──────────────────────────────
    if [ "$DRY_RUN" = true ]; then
      dry "Would add $skill_name/ (new)"
    else
      cp -r "$skill_dir" "$dest_dir"
      added "$skill_name/ (new)"
    fi
    count_added=$((count_added + 1))

  elif [ ! -f "$dest_skill" ]; then
    # ── Dir exists but SKILL.md is missing — restore it ────────────────────
    if [ "$DRY_RUN" = true ]; then
      dry "Would restore $skill_name/SKILL.md (missing)"
    else
      cp "$src_skill" "$dest_skill"
      added "$skill_name/SKILL.md (restored)"
    fi
    count_added=$((count_added + 1))

  elif cmp -s "$src_skill" "$dest_skill"; then
    # ── Files are identical — already current ──────────────────────────────
    count_current=$((count_current + 1))

  elif [ "$FORCE" = true ]; then
    # ── Files differ, force mode — overwrite ───────────────────────────────
    if [ "$DRY_RUN" = true ]; then
      dry "Would overwrite $skill_name/SKILL.md (forced)"
    else
      cp "$src_skill" "$dest_skill"
      updated "$skill_name/SKILL.md (forced)"
    fi
    count_updated=$((count_updated + 1))

  else
    # ── Files differ, safe mode — report delta then skip ───────────────────
    src_date=$(awk '/^---/{f=!f; next} f && /^updated:/{sub(/^updated:[[:space:]]*/, ""); print; exit}' "$src_skill")
    dest_date=$(awk '/^---/{f=!f; next} f && /^updated:/{sub(/^updated:[[:space:]]*/, ""); print; exit}' "$dest_skill")
    if [ -n "$src_date" ] && [ -n "$dest_date" ] && [ "$src_date" != "$dest_date" ]; then
      skipped "$skill_name (source: $src_date, installed: $dest_date) — run with --force to update"
    else
      skipped "$skill_name (local changes — skipped)"
    fi
    skipped_names+=("$skill_name")
    count_skipped=$((count_skipped + 1))
  fi
done

# ── Update skills/README.md ───────────────────────────────────────────────────

src_readme="$SKILLS_SRC/README.md"
dest_readme="$SKILLS_DEST/README.md"

if [ -f "$src_readme" ]; then
  if [ ! -f "$dest_readme" ]; then
    if [ "$DRY_RUN" = true ]; then
      dry "Would add skills/README.md"
    else
      cp "$src_readme" "$dest_readme"
      added "skills/README.md"
    fi
  elif cmp -s "$src_readme" "$dest_readme"; then
    : # already current, nothing to do
  elif [ "$FORCE" = true ]; then
    if [ "$DRY_RUN" = true ]; then
      dry "Would overwrite skills/README.md (forced)"
    else
      cp "$src_readme" "$dest_readme"
      updated "skills/README.md (forced)"
    fi
  else
    skipped "skills/README.md (local changes — skipped)"
    skipped_names+=("skills/README.md")
    count_skipped=$((count_skipped + 1))
  fi
fi

# ── Update hooks (--with-hooks) ───────────────────────────────────────────────

if [ "$WITH_HOOKS" = true ]; then
  HOOKS_DEST="$PROJECT_DIR/hooks"
  if [ -d "$HOOKS_DEST" ]; then
    echo "Hooks:"
    for src_hook in "$AGENT_CONFIG_DIR/hooks/"*.sh; do
      [ -f "$src_hook" ] || continue
      hook_name=$(basename "$src_hook")
      dest_hook="$HOOKS_DEST/$hook_name"
      if [ ! -f "$dest_hook" ]; then
        if [ "$DRY_RUN" = true ]; then
          dry "Would add hooks/$hook_name"
        else
          cp "$src_hook" "$dest_hook"
          chmod +x "$dest_hook"
          added "hooks/$hook_name (new)"
        fi
      elif cmp -s "$src_hook" "$dest_hook"; then
        : # current
      elif [ "$FORCE" = true ]; then
        if [ "$DRY_RUN" = true ]; then
          dry "Would overwrite hooks/$hook_name (forced)"
        else
          cp "$src_hook" "$dest_hook"
          chmod +x "$dest_hook"
          updated "hooks/$hook_name (forced)"
        fi
      else
        skipped "hooks/$hook_name (local changes — skipped)"
      fi
    done
    echo ""
  else
    log "No hooks/ directory found — run with --with-hooks after init.sh --with-hooks to create it"
  fi
fi

# ── Update instructions (--with-instructions) ─────────────────────────────────

if [ "$WITH_INSTRUCTIONS" = true ]; then
  INSTR_DEST="$PROJECT_DIR/.github/instructions"
  if [ -d "$INSTR_DEST" ]; then
    echo "Instructions:"
    for src_instr in "$AGENT_CONFIG_DIR/instructions/"*.instructions.md; do
      [ -f "$src_instr" ] || continue
      instr_name=$(basename "$src_instr")
      dest_instr="$INSTR_DEST/$instr_name"
      if [ ! -f "$dest_instr" ]; then
        if [ "$DRY_RUN" = true ]; then
          dry "Would add .github/instructions/$instr_name"
        else
          cp "$src_instr" "$dest_instr"
          added ".github/instructions/$instr_name (new)"
        fi
      elif cmp -s "$src_instr" "$dest_instr"; then
        : # current
      elif [ "$FORCE" = true ]; then
        if [ "$DRY_RUN" = true ]; then
          dry "Would overwrite .github/instructions/$instr_name (forced)"
        else
          cp "$src_instr" "$dest_instr"
          updated ".github/instructions/$instr_name (forced)"
        fi
      else
        skipped ".github/instructions/$instr_name (local changes — skipped)"
      fi
    done
    echo ""
  else
    log "No .github/instructions/ directory found — run with --with-instructions after init.sh --with-instructions to create it"
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Done."
[ $count_added -gt 0 ]   && log "$count_added added"
[ $count_updated -gt 0 ] && log "$count_updated updated (forced)"
[ $count_current -gt 0 ] && log "$count_current already current"
[ $count_skipped -gt 0 ] && log "$count_skipped skipped (local changes)"
echo ""

if [ ${#skipped_names[@]} -gt 0 ]; then
  echo "Skipped skills have local changes and may be out of date."
  echo "To review a diff before deciding:"
  for name in "${skipped_names[@]}"; do
    echo "  diff $SKILLS_SRC/$name/SKILL.md $SKILLS_DEST/$name/SKILL.md"
  done
  echo ""
  echo "To force-update a single skill (overwrites local changes):"
  for name in "${skipped_names[@]}"; do
    echo "  cp $SKILLS_SRC/$name/SKILL.md $SKILLS_DEST/$name/SKILL.md"
  done
  echo ""
fi
