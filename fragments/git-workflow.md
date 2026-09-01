## Git Workflow

`main` is the only long-lived branch. Never push to `main` directly — every
change goes through a short-lived branch and a PR.

### Branching

- Before starting any task, work from an up-to-date `main`: `git fetch origin`,
  then branch from `origin/main`. Prefer that over `checkout main && pull` when
  another session may share the checkout — fetching moves no local ref, so it
  cannot pull the ground out from under it.
- One branch per task, named `type/kebab-description`, where `type` is one of
  `feat | fix | refactor | chore | docs | perf`.
- Squash-merge the PR, then delete the branch. Granular commits serve the
  branch's life, not `main`'s history.

### PR lifecycle (open early, keep current)

1. After the first commit and push, open a **draft** PR. A PR cannot be opened
   with zero commits, so the first push is the trigger.
2. The body always carries the first two sections, and the rest only when they
   apply — drop the ones that do not:
   - **Why** — the problem or the goal, in one to three sentences.
   - **Changes** — `[+]` added · `[&]` changed · `[!]` fixed · `[-]` removed.
   - **State** — *when the work has several steps*: a checklist, each item
     ticked once its commit is pushed. This is what makes progress readable at a
     glance.
   - **Deployment notes** — *when relevant*: a new environment variable, a
     secret, a migration, a service ordering. Assembled from what the work
     reported, never guessed off the diff.
   - **Known issues** — *when applicable*: things found but deliberately left
     unfixed as out of scope.
   - **Related PRs** — *when cross-repo*: as `owner/repo#number`.
3. After every push, update the PR body: tick what landed, refresh what moved.
   Editing a body replaces the whole document, so only the session that owns the
   PR writes it — a second writer working from a stale copy erases whatever
   landed in between.
4. Mark the PR ready for review once the work is complete and CI is green.

### Working on the right code (CRUCIAL)

- Any analysis, investigation or bug fix starts by checking the branch: be on
  the repo's default branch and up to date before reading the code, unless the
  task explicitly targets another branch. Analysing a stale checkout produces
  conclusions about code that no longer exists.
- **This does not apply inside a task worktree** — being handed one *is* being
  pointed at another branch. Never `checkout` or `pull` there.
- When looking for a branch, `git fetch origin` first: the local clone does not
  have every remote branch, and a branch listing without a fresh fetch lies.

### Never

- Never `git checkout .`, `git reset --hard` or `git clean -fd` over
  uncommitted work without saying what is about to be destroyed and getting a
  yes. There is no undo.
- Never rewrite history on a branch that has been pushed and shared.
- Never merge your own PR unless the user asked for it explicitly.
