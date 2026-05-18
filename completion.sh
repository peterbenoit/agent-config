#!/usr/bin/env bash
# completion.sh — shell completions for agent-config
#
# Generates tab completions for init.sh (--select, --template) and search.sh.
#
# Usage:
#   source <(~/GitHub/agent-config/completion.sh)       # activate for this session
#   ~/GitHub/agent-config/completion.sh --install-zsh   # append to ~/.zshrc
#   ~/GitHub/agent-config/completion.sh --install-bash  # append to ~/.bashrc

AGENT_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$AGENT_CONFIG_DIR/skills"
TEMPLATES_DIR="$AGENT_CONFIG_DIR/templates"

_skill_names() {
  for d in "$SKILLS_DIR"/*/; do
    local name; name=$(basename "$d")
    [ -f "$d/SKILL.md" ] && printf '%s\n' "$name"
  done
}

_template_names() {
  for f in "$TEMPLATES_DIR"/agents-*.md; do
    [ -f "$f" ] && basename "$f" .md | sed 's/^agents-//'
  done
}

emit_zsh() {
  local skills; skills=$(_skill_names | tr '\n' ' ')
  local templates; templates=$(_template_names | tr '\n' ' ')

  printf '%s\n' "# agent-config zsh completions"
  printf '%s\n' "_ac_skills() { echo '$skills'; }"
  printf '%s\n' "_ac_templates() { echo '$templates'; }"
  printf '%s\n' ""
  printf '%s\n' "_agent_config_init() {"
  printf '%s\n' "  local state context"
  printf '%s\n' "  _arguments -C \\"
  printf '%s\n' "    '--select[install only named skills]: :->skills' \\"
  printf '%s\n' "    '--template[use agents-NAME.md starter]: :->templates' \\"
  printf '%s\n' "    '--with-hooks[also install block-dangerous-git.sh]' \\"
  printf '%s\n' "    '--with-instructions[also install .instructions.md files]' \\"
  printf '%s\n' "    '--link[symlink skills instead of copying]' \\"
  printf '%s\n' "    '--dry-run[preview changes without writing]'"
  printf '%s\n' "  case \$state in"
  printf '%s\n' "    skills)    compadd -s ',' \$(_ac_skills) ;;"
  printf '%s\n' "    templates) compadd \$(_ac_templates) ;;"
  printf '%s\n' "  esac"
  printf '%s\n' "}"
  printf '%s\n' "_agent_config_search() { _arguments '1:query: '; }"
  printf '%s\n' "compdef _agent_config_init init.sh"
  printf '%s\n' "compdef _agent_config_search search.sh"
}

emit_bash() {
  local skills; skills=$(_skill_names | tr '\n' ' ')
  local templates; templates=$(_template_names | tr '\n' ' ')

  printf '%s\n' "# agent-config bash completions"
  printf '%s\n' "_agent_config_init_complete() {"
  printf '%s\n' "  local cur=\"\${COMP_WORDS[COMP_CWORD]}\" prev=\"\${COMP_WORDS[COMP_CWORD-1]}\""
  printf '%s\n' "  case \"\$prev\" in"
  printf '%s\n' "    --select)   COMPREPLY=(\$(compgen -W '$skills' -- \"\$cur\")); return ;;"
  printf '%s\n' "    --template) COMPREPLY=(\$(compgen -W '$templates' -- \"\$cur\")); return ;;"
  printf '%s\n' "  esac"
  printf '%s\n' "  COMPREPLY=(\$(compgen -W '--select --template --with-hooks --with-instructions --link --dry-run' -- \"\$cur\"))"
  printf '%s\n' "}"
  printf '%s\n' "complete -F _agent_config_init_complete init.sh"
}

case "${1:-}" in
  --install-zsh)
    MARKER="# agent-config completions"
    if grep -q "$MARKER" ~/.zshrc 2>/dev/null; then
      echo "agent-config completions already in ~/.zshrc"
    else
      { printf '\n%s\n' "$MARKER"; printf 'source <("%s")\n' "$AGENT_CONFIG_DIR/completion.sh"; } >> ~/.zshrc
      echo "Appended to ~/.zshrc. Run: source ~/.zshrc"
    fi
    ;;
  --install-bash)
    MARKER="# agent-config completions"
    if grep -q "$MARKER" ~/.bashrc 2>/dev/null; then
      echo "agent-config completions already in ~/.bashrc"
    else
      { printf '\n%s\n' "$MARKER"; printf 'source <("%s")\n' "$AGENT_CONFIG_DIR/completion.sh"; } >> ~/.bashrc
      echo "Appended to ~/.bashrc. Run: source ~/.bashrc"
    fi
    ;;
  --help|-h)
    echo "Usage: completion.sh [option]"
    echo "  (no args)        Output completion code for current shell"
    echo "  --install-zsh    Append source line to ~/.zshrc"
    echo "  --install-bash   Append source line to ~/.bashrc"
    ;;
  *)
    if [ -n "$ZSH_VERSION" ] || [[ "$SHELL" == */zsh ]]; then
      emit_zsh
    else
      emit_bash
    fi
    ;;
esac
