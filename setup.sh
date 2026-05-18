#!/usr/bin/env bash
# setup.sh — one-command global wiring for agent-config
#
# Creates (or verifies) global symlinks so skills, prompts, and instructions
# are available in Claude Code, VS Code Copilot, Codex, and compatible agents.
#
# Usage:
#   ./setup.sh              # create missing symlinks, skip existing ones
#   ./setup.sh --dry-run    # preview what would be done, no changes
#   ./setup.sh --force      # replace incorrect symlinks
#
# What it creates:
#   ~/.agents/skills        → agent-config/skills/
#   ~/.claude/skills        → agent-config/skills/
#   ~/.codex/skills         → agent-config/skills/
#   ~/Library/.../User/prompts/*.prompt.md     symlinked from agent-config/prompts/
#   ~/Library/.../User/instructions/*.instructions.md  symlinked from agent-config/instructions/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
PROMPTS_SRC="$SCRIPT_DIR/prompts"
INSTRUCTIONS_SRC="$SCRIPT_DIR/instructions"
VSCODE_PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"
VSCODE_INSTRUCTIONS_DIR="$HOME/Library/Application Support/Code/User/instructions"

DRY_RUN=false
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --force)   FORCE=true ;;
    --help|-h)
      echo "Usage: ./setup.sh [--dry-run] [--force]"
      echo "  --dry-run  Preview changes without making them"
      echo "  --force    Replace symlinks that point to the wrong target"
      exit 0
      ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 1
      ;;
  esac
done

created=0
skipped=0
fixed=0
errors=0

green="\033[0;32m"
yellow="\033[0;33m"
red="\033[0;31m"
reset="\033[0m"

log_create() { echo -e "  ${green}create${reset}  $1 → $2"; }
log_skip()   { echo -e "  skip    $1 (already correct)"; }
log_wrong()  { echo -e "  ${yellow}wrong${reset}   $1 → $2 (expected $3)"; }
log_fix()    { echo -e "  ${green}fix${reset}     $1 → $2"; }
log_error()  { echo -e "  ${red}error${reset}   $1: $2"; ((errors++)) || true; }

# Wire a single symlink: target_path source
wire_symlink() {
  local target_path="$1"
  local source="$2"
  local expanded="${target_path/#\~/$HOME}"
  local parent_dir
  parent_dir=$(dirname "$expanded")

  if [ -L "$expanded" ]; then
    existing=$(readlink "$expanded")
    if [ "$existing" = "$source" ]; then
      log_skip "$target_path"
      ((skipped++)) || true
      return
    else
      log_wrong "$target_path" "$existing" "$source"
      if [ "$FORCE" = true ]; then
        if [ "$DRY_RUN" = false ]; then
          rm "$expanded"
          ln -s "$source" "$expanded"
          log_fix "$target_path" "$source"
        else
          echo "    [dry-run] would remove and recreate"
        fi
        ((fixed++)) || true
      else
        echo "    run with --force to fix"
      fi
      return
    fi
  fi

  if [ -e "$expanded" ]; then
    log_error "$target_path" "exists but is not a symlink — remove it manually first"
    return
  fi

  # Create parent dir if needed
  if [ ! -d "$parent_dir" ]; then
    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$parent_dir"
    fi
  fi

  log_create "$target_path" "$source"
  if [ "$DRY_RUN" = false ]; then
    ln -s "$source" "$expanded"
  fi
  ((created++)) || true
}

# Wire all files matching a glob from src_dir into dest_dir as individual symlinks
wire_file_symlinks() {
  local src_dir="$1"
  local dest_dir="$2"
  local pattern="$3"

  if [ ! -d "$dest_dir" ]; then
    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$dest_dir"
    else
      echo "    [dry-run] would create $dest_dir"
    fi
  fi

  for src_file in "$src_dir"/$pattern; do
    [ -f "$src_file" ] || continue
    local file_name
    file_name=$(basename "$src_file")
    local dest_file="$dest_dir/$file_name"

    if [ -L "$dest_file" ]; then
      existing=$(readlink "$dest_file")
      if [ "$existing" = "$src_file" ]; then
        log_skip "$(basename "$dest_dir")/$file_name"
        ((skipped++)) || true
      else
        log_wrong "$(basename "$dest_dir")/$file_name" "$existing" "$src_file"
        if [ "$FORCE" = true ]; then
          if [ "$DRY_RUN" = false ]; then
            rm "$dest_file"
            ln -s "$src_file" "$dest_file"
            log_fix "$(basename "$dest_dir")/$file_name" "$src_file"
          else
            echo "    [dry-run] would remove and recreate"
          fi
          ((fixed++)) || true
        else
          echo "    run with --force to fix"
        fi
      fi
    elif [ -e "$dest_file" ]; then
      log_error "$(basename "$dest_dir")/$file_name" "exists but is not a symlink — remove it manually"
    else
      log_create "$(basename "$dest_dir")/$file_name" "$src_file"
      if [ "$DRY_RUN" = false ]; then
        ln -s "$src_file" "$dest_file"
      fi
      ((created++)) || true
    fi
  done
}

echo "agent-config setup"
echo "Source: $SKILLS_SRC"
[ "$DRY_RUN" = true ] && echo "(dry run — no changes will be made)"
echo ""

echo "── Global skill symlinks ──"
wire_symlink "~/.agents/skills" "$SKILLS_SRC"
wire_symlink "~/.claude/skills" "$SKILLS_SRC"
wire_symlink "~/.codex/skills"  "$SKILLS_SRC"

echo ""
echo "── VS Code Copilot: prompts ──"
wire_file_symlinks "$PROMPTS_SRC" "$VSCODE_PROMPTS_DIR" "*.prompt.md"

echo ""
echo "── VS Code Copilot: instructions ──"
wire_file_symlinks "$INSTRUCTIONS_SRC" "$VSCODE_INSTRUCTIONS_DIR" "*.instructions.md"

echo ""
echo "────────────────────────────────"
echo "Created: $created  Fixed: $fixed  Skipped: $skipped  Errors: $errors"

if [ $errors -gt 0 ]; then
  echo "Some symlinks could not be created. See errors above."
  exit 1
fi

if [ "$DRY_RUN" = false ] && [ $((created + fixed)) -gt 0 ]; then
  echo ""
  echo "Done. Run ./validate.sh to confirm all symlinks are healthy."
fi
