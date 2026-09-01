---
name: onboard-repo
description: Map an unfamiliar codebase and explain in plain words how it works, then optionally draft a CLAUDE.md for it. Use when starting work on a repo for the first time, when the user asks what a project does, how it is structured, where something lives, or asks to set up or initialise Claude for a repository.
---

# Onboard onto a repo

The goal is a mental model, not an inventory. A directory listing tells the user
nothing they could not get from `ls`.

## 1. Read the outside first

In this order, because each one explains the next:

- `README.md` — what it claims to be.
- The manifest: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`. The
  dependency list is the architecture in disguise — a web framework, an ORM, a
  queue client and a payment SDK describe the system faster than any document.
  The scripts section tells you how the project is run, tested and built.
- `CLAUDE.md`, `CONTRIBUTING.md`, `docs/` — the rules that already exist.
- CI config — what has to be green, and how it is actually run.
- `.env.example` — what the system talks to.

## 2. Find the seams

- **The entry points**: the `main`, the server bootstrap, the CLI command, the
  route or page directory. Follow one request or one command all the way
  through. One traced path teaches more than reading twenty files.
- **The data**: models, schemas, migrations. What are the three or four nouns
  this system is really about?
- **The boundaries**: where it calls out — databases, APIs, queues, third
  parties.
- **The conventions**: open two or three files of the same kind and see what
  they have in common. That pattern is the house style, and new code follows it
  whether or not it is written down anywhere.

Use search rather than reading everything. Look for the words that matter in
this domain, not for files.

## 3. Explain it

In plain words, without a directory tree:

- What the system does and for whom, in two sentences.
- The three or four main pieces and what each is responsible for.
- How a typical request or run flows through them.
- What it depends on outside itself.
- How to run it, test it, and what checks must pass.
- What looks fragile, unusual or surprising — the parts that will bite. Say it
  plainly, including when the answer is that the code is a mess in a specific
  place.

Say what you did not read. A confident map of a repo you skimmed is worse than
an honest partial one.

## 4. Offer a CLAUDE.md

If the repo has none, offer to draft one — do not write it unprompted. Keep it
to what is not visible in the code: the why, the principles, the conventions,
the commands that matter, the traps. No file tree, no package list, nothing that
goes stale at the first refactor. If it needs updating every commit, it is too
specific.

Import the shared fragments at the top of it (see the Skills README) rather than
restating standards inside the project.
