## General Defaults

Cross-project defaults that hold in every repository, whatever the language.

### Follow the repo, not a habit (CRUCIAL)

Before adding a tool, a config file or a convention, look at what the repository
already does and use that. A repo with `npm` scripts does not need a `Makefile`;
a repo with `ruff` does not need `flake8` added beside it. New tooling is a
decision to argue for, not a default to install.

When nothing exists yet and a runner is genuinely needed, add the smallest one
the ecosystem already expects: `package.json` scripts for a Node repo, a
`Makefile` or `justfile` for anything else. Define only the recipes actually
used — no command "just in case".

### Comments must not rot (CRUCIAL)

A comment is written once and read for years while the code under it keeps
moving. Anything a comment states that the code can change on its own becomes a
lie eventually, and nothing catches it: no compiler, no test, no reviewer flags
a comment that quietly stopped being true. So a comment may only say things that
survive the next edit.

- **No hardcoded values.** Never restate a literal the code already holds —
  limits, timeouts, sizes, ports, counts, prices, version numbers, field lists.
  Say what the value is *for* and let the reader look at it: "retries transient
  failures with exponential backoff", not "retries 5 times, 2s apart".
- **No temporal statements.** Nothing whose truth depends on when it is read:
  "new", "current", "for now", "temporary", "recently added", "replaces the old
  X", dates, sprint or release numbers. Git history already records when and why
  something changed.
- **Describe intent and invariants, not state.** Why the code exists and what
  must hold are stable; what the value happens to be today is not.
- **Exception**: a constraint that lives *outside* the codebase — a third-party
  API limit, a protocol constant, a spec requirement — may be cited when it is
  the reason the code is shaped that way, named with its source so a reader can
  re-check it.
- TODO comments stay allowed: they describe work left to do, never a date or a
  release it is promised for.

### Write less code

The best change is the one that deletes code. Before writing a new helper,
search for one that already does the job — duplicated logic is the defect that
outlives every other kind. Before adding an abstraction, check that it has at
least two real callers today; one caller and a guess about the future is how
codebases get hard to move.

Keep the public surface minimal: export what callers need, not everything that
happens to be defined.

### Dependencies

Adding a dependency is a permanent decision made in a few seconds. Add one when
it replaces code that would be genuinely hard to get right — dates, crypto,
parsers, HTTP clients — and write the ten lines yourself when it would not.
Never add one without saying so in the reply and in the PR body.

### Secrets and configuration

No secret, token, API key, connection string or internal hostname ever reaches a
committed file, a log line, a test fixture or an error message. They come from
the environment, and the repo documents which variables exist, never their
values. When a new one is needed, say so — it will not appear on its own in the
deployment.

### CLAUDE.md design (CRUCIAL)

- A project CLAUDE.md describes the **why** and the **principles**, not the file
  tree or the package list.
- No architecture diagrams with exact directory listings — they go stale at the
  first refactor and are then worse than nothing.
- Describe the architecture *style* and its rules. The code documents its own
  structure; CLAUDE.md captures what is not visible in the code.
- A good CLAUDE.md rarely needs updating. If it changes at every commit, it is
  too specific.
