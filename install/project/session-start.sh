#!/usr/bin/env bash
#
# Project-level session start hook.
#
# Copy this file to .claude/hooks/session-start.sh in a project, register it in
# that project's .claude/settings.json (see settings.json beside this file), and
# commit both. Every session on that repo — local, and above all Claude Code on
# the web, where nothing from your machine exists — then gets the shared
# standards, and whatever else you add at the bottom.
#
# Deliberately synchronous: the session waits for it. The fragments a project
# imports with @ have to exist before the session reads its CLAUDE.md, and an
# async hook would start the session while the clone is still running.

set -uo pipefail

# --- Shared standards -------------------------------------------------------
# Clones ~/Skills if it is not there, pulls it if it is, then installs its
# skills, agents and commands. Safe to run repeatedly, and never fatal: a
# session with older standards beats a session that refuses to start.

REPO_URL="https://github.com/SweathX/Skills"

[ -d "$HOME/Skills/.git" ] \
  || git clone --quiet "$REPO_URL" "$HOME/Skills" \
  || echo "Skills: clone failed, this session runs without the shared standards" >&2

[ -d "$HOME/Skills/.git" ] && bash "$HOME/Skills/install/sync.sh"

# --- Project setup ----------------------------------------------------------
# Add what this repo needs in order to run its own tests and linters in a fresh
# container: dependency installs, a generated client, environment variables via
# "$CLAUDE_ENV_FILE". Keep it idempotent and non-interactive.
#
# Guard anything slow so it only runs on the web, where the container is empty:
#
#   if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
#     npm install
#   fi

exit 0
