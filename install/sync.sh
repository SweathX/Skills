#!/usr/bin/env bash
#
# Keeps the ~/Skills clone fresh and installs everything Claude Code loads from
# it at user scope, so one clone per machine serves every project.
#
# Run by the SessionStart hook (see README.md). Never exits non-zero on a
# failure it can survive: a session that starts with an older copy is better
# than a session that refuses to start.

set -uo pipefail

REPO_URL="https://github.com/SweathX/Skills"
REPO_DIR="${SKILLS_DIR:-$HOME/Skills}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

log() { printf 'Skills: %s\n' "$1" >&2; }

if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull --ff-only --quiet \
    || log "pull failed, this machine is running an older copy"
else
  git clone --quiet "$REPO_URL" "$REPO_DIR" || { log "clone failed"; exit 0; }
fi

# Copy to a staging path and swap only once the copy succeeded, so an
# interrupted sync leaves the previous definitions in place rather than
# uninstalling them silently.
install_tree() { # <src-dir> <dest-dir>
  local src=$1 dest=$2 staging
  [ -d "$src" ] || return 0
  staging="$dest.incoming"
  rm -rf "$staging"
  mkdir -p "$(dirname "$dest")"
  if cp -R "$src" "$staging"; then
    rm -rf "$dest"
    mv "$staging" "$dest"
  else
    log "copy of $src failed, keeping the previous install"
    rm -rf "$staging"
  fi
}

# Agents and commands live in a subdirectory of their own, so personal
# definitions sitting directly under ~/.claude are never touched.
install_tree "$REPO_DIR/agents" "$CLAUDE_DIR/agents/skills"
install_tree "$REPO_DIR/commands" "$CLAUDE_DIR/commands/skills"

# Skills are discovered one level under ~/.claude/skills, next to personal ones,
# so they cannot be namespaced in a subdirectory. They are installed by name and
# tracked in a manifest instead: a skill deleted from the repo disappears here,
# and anything not in the manifest is left alone.
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="$CLAUDE_DIR/skills"
MANIFEST="$SKILLS_DEST/.from-skills-repo"

if [ -d "$SKILLS_SRC" ]; then
  mkdir -p "$SKILLS_DEST"
  installed=""
  for dir in "$SKILLS_SRC"/*/; do
    [ -f "$dir/SKILL.md" ] || continue
    name=$(basename "$dir")
    rm -rf "${SKILLS_DEST:?}/$name.incoming"
    if cp -R "${dir%/}" "$SKILLS_DEST/$name.incoming"; then
      rm -rf "${SKILLS_DEST:?}/$name"
      mv "$SKILLS_DEST/$name.incoming" "$SKILLS_DEST/$name"
    else
      log "copy of skill '$name' failed, keeping the previous version"
      rm -rf "${SKILLS_DEST:?}/$name.incoming"
    fi
    # Recorded either way: on a failed copy the previous version is still
    # installed, and dropping it from the manifest would delete it below.
    installed="${installed}${name}"$'\n'
  done

  if [ -f "$MANIFEST" ]; then
    while IFS= read -r old; do
      [ -n "$old" ] || continue
      case $'\n'"$installed" in
        *$'\n'"$old"$'\n'*) ;;
        *) rm -rf "${SKILLS_DEST:?}/$old" ;;
      esac
    done < "$MANIFEST"
  fi

  printf '%s' "$installed" > "$MANIFEST"
fi
