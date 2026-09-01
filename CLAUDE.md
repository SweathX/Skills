# CLAUDE.md

This repository is the shared Claude Code setup consumed by every other project:
instruction fragments imported through `@`, skills and subagents installed at
user scope, and slash commands. See README.md for how it is wired.

## Editing rules

- All content in English, whatever language the conversation is in.
- Everything stays **project-agnostic**: no project names, no credentials, no
  internal URLs, ids or hostnames. Anything specific belongs in the consuming
  project's own CLAUDE.md.
- One file, one theme. A new cross-cutting default goes to
  `fragments/general.md`; a new language gets its own
  `fragments/<lang>-style.md`.
- **Prose over bullet soup.** These files are prompts: a rule needs the sentence
  that says why, or it gets followed literally in the one case it should not.
  State the rule, then the reason it exists.
- Keep it short. Every line here is loaded into sessions that have other work to
  do, and a fragment nobody finishes reading is worse than one that says less.

## When adding a skill

The `description` field is the whole trigger — it is what Claude reads to decide
whether the skill applies. Write it as *when* to use this, in the words the user
would actually use, and say what it is **not** for when a neighbouring skill
exists.

Add the skill to the README table in the same commit.

## Propagation

Every change lands on `main` and reaches every machine at the next session
start. The install is a replace: deleting a skill, agent or command here removes
it everywhere. Treat each edit as immediately live.

@~/Skills/fragments/commit-convention.md
