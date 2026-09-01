# Skills

My shared Claude Code setup: engineering standards imported into every project,
the skills and subagents Claude loads automatically, and the slash commands I
use daily. One clone per machine, at `~/Skills`, kept fresh on its own — so
every session on every machine runs the latest version.

Four kinds of thing live here, and they are not the same tool:

| | What it is | How it reaches Claude |
|---|---|---|
| `fragments/` | Standards: style, git, testing, tone | Imported with `@` in a project's `CLAUDE.md` |
| `skills/` | Procedures: how to debug, plan, ship | Loaded **automatically** when the task matches |
| `agents/` | Subagents with a fixed role and model | Dispatched by name, from a command or by Claude |
| `commands/` | Slash commands | Typed: `/skills:review` |

Plus `docs/`, which is for me rather than for Claude — the two guides that
explain how to actually use all of it.

## One-time setup, per machine

```bash
git clone https://github.com/SweathX/Skills ~/Skills
```

Then add this `SessionStart` hook to `~/.claude/settings.json` — **user scope,
not per project**, so one copy serves every repo and there is nothing to keep in
sync:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "[ -d \"$HOME/Skills/.git\" ] || git clone --quiet https://github.com/SweathX/Skills \"$HOME/Skills\"; bash \"$HOME/Skills/install/sync.sh\""
          }
        ]
      }
    ]
  }
}
```

At every session start, `install/sync.sh` pulls the clone and installs:

- `agents/` → `~/.claude/agents/skills/`
- `commands/` → `~/.claude/commands/skills/` (so they are typed `/skills:name`)
- `skills/` → `~/.claude/skills/`, one directory per skill

Each install copies to a staging path and swaps it in only once the copy
succeeded, so an interrupted sync leaves the previous version in place rather
than silently uninstalling it. Agents and commands sit in a subdirectory of
their own, and skills are tracked in a manifest — personal definitions living
beside them are never touched. It is a replace, so **deleting something here
removes it everywhere at the next session start**.

Everything loads at session start, not live: after changing an agent or a
skill, restart the session before relying on it.

If a dispatch fails with an unknown agent type, this install is why — check that
`~/.claude/agents/skills/` exists and restart.

## Wiring a project

Put the imports at the top of the project's `CLAUDE.md` (create the file if
there is none), keeping only the lines that apply:

```
@~/Skills/fragments/general.md
@~/Skills/fragments/vibe.md
@~/Skills/fragments/git-workflow.md
@~/Skills/fragments/commit-convention.md
@~/Skills/fragments/testing.md
@~/Skills/fragments/ts-style.md
```

That is the whole wiring — skills, agents and commands are already installed at
user scope.

Swap `ts-style` for `python-style`, or import both. In a repo with a Python
service under one directory and a TypeScript app under another, put the language
line in a `CLAUDE.md` inside each subdirectory so it loads only when files there
are touched.

Drop `vibe.md` in any repo whose diffs you actually read: it tells Claude to
keep code out of its replies, which is wrong when you want to see it.

## Fragments

| File | Contents |
|---|---|
| `general.md` | Cross-language defaults: follow the repo's tooling, comments that do not rot, dependencies, secrets, CLAUDE.md design |
| `vibe.md` | Tone and format: answer first, plain words, reply in the user's language, no code in replies |
| `git-workflow.md` | Branching model, PR lifecycle, working on the right checkout |
| `commit-convention.md` | Commit message format |
| `testing.md` | What deserves a test, what a test must never do |
| `ts-style.md` | TypeScript / JavaScript, React, Next.js, Node |
| `python-style.md` | Python |

## Skills

Loaded automatically when what you are doing matches the description — you do
not invoke them.

| Skill | Fires when |
|---|---|
| `plan-feature` | Building something that gives a capability that does not exist yet: spec, approval, batched plan, then the build |
| `debug-systematically` | Anything is broken, failing or unexplained: reproduce, narrow, name the cause, prove the fix |
| `review-before-push` | Before a commit, a push or a PR: read the diff adversarially, hunt leftovers and secrets, run the checks |
| `ship-pr` | Committing, pushing, opening or updating a pull request |
| `onboard-repo` | First contact with a codebase: map it, explain it in plain words, offer a CLAUDE.md |

## Agents

| Agent | Model | Effort | Role |
|---|---|---|---|
| `plan-reviewer` | inherit | high | Reviews the spec and the plan together, before any code exists |
| `implementer` | sonnet | inherit | Implements one batch of a plan, commits it, reports back |
| `diff-reviewer` | opus | max | Reviews the finished change end to end before a human sees it |

`diff-reviewer` runs at `max` because it holds the whole change at once and is
the only pass over the code; the two earlier roles read two documents or one
batch. `plan-reviewer` deliberately pins no model — it inherits the session's,
so a session on a strong model gets a strong gate and one deliberately running
cheap is not dragged back up.

The reviewers are read-only by prompt, not by construction: they hold `Bash`
because they need `git` and the build, and `Bash` can write. `implementer` is
denied `Agent`, so nothing below the orchestrator can fan out — that part is
structural. Treat a violation as a bug to fix, not as something the
configuration prevents.

A project's `CLAUDE.md` loads inside every subagent, so these definitions carry
role protocol only — code style, commit format and the rest come from the
fragments the project imports.

## Commands

| Command | What it does |
|---|---|
| `/skills:feature` | Runs the full flow: spec, approval, plan review, batched build, final review |
| `/skills:review` | Self-review of the current change plus an independent `diff-reviewer` pass |
| `/skills:pr` | Checks, branch, commit, push, draft PR with the house body |
| `/skills:explain` | Explains a file, a feature or the current change in plain words, no code |

## Docs

- [`docs/vibe-coding-101.md`](docs/vibe-coding-101.md) — directing a project you
  do not read the code of: the habits, the failure patterns, and where the
  approach stops.
- [`docs/claude-code-playbook.md`](docs/claude-code-playbook.md) — the Claude
  Code features that actually change throughput: context, CLAUDE.md, plan mode,
  skills, subagents, commands, hooks, MCP, worktrees.

## Rules of this repo

Everything here is **project-agnostic**: no project names, no credentials, no
internal URLs or ids, no host names. Anything specific belongs in the consuming
project's own `CLAUDE.md`.

One file, one theme. A new cross-cutting default goes to `general.md`; a new
language gets its own `<lang>-style.md`.

Changes land on `main` and reach every machine at the next session start — treat
each edit as immediately live everywhere.
