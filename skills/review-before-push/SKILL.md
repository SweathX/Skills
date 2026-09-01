---
name: review-before-push
description: Self-review a change before committing or pushing it — re-read the diff adversarially, run the repo's checks, and catch leftovers, secrets and scope creep. Use before any commit, push or pull request, when the user asks to review changes, check the work, or asks whether something is ready to ship.
---

# Review before push

The cheapest review is the one you do on your own diff, before anyone else sees
it. It takes two minutes and catches most of what a reviewer would send back.

## 1. Look at what you are actually shipping

Run `git status` and `git diff` (and `git diff --staged`). Read the whole thing,
not the parts you remember writing.

Then ask, file by file:

- **Does this file belong in the diff?** A stray `.env`, a build artifact, a
  `node_modules` entry, a lockfile you did not mean to change, a scratch script,
  a fixture you used once.
- **Is anything here not part of the task?** An unrelated rename, a drive-by
  refactor, a reformatted file whose diff is now unreadable. Split it out or
  drop it — scope creep is what makes a small PR unreviewable.
- **Did anything get deleted that should not have been?** Look at the removed
  lines, not just the added ones.

## 2. Hunt the leftovers

- Debug prints, `console.log`, `print()`, breakpoints, `debugger`.
- Commented-out code — delete it, git remembers.
- `TODO` you wrote ten minutes ago and meant to finish.
- A hardcoded URL, port, path, id or token that should come from config.
- **Any secret at all**: key, password, connection string, internal hostname. If
  one was ever committed, say so immediately — it has to be rotated, not just
  removed.
- A test you skipped, commented out, or weakened to get green.

## 3. Re-read it adversarially

Read your own diff as if you were trying to reject it:

- What input makes this crash? Empty, null, missing field, huge, negative,
  duplicate, unauthorised, concurrent.
- What happens when the thing it depends on fails — the network call, the
  database, the file that is not there? Is that failure visible, or swallowed?
- Is any error being caught and ignored?
- Does this change behaviour for existing users or existing data? Say so.
- Is there now duplicated logic that already existed elsewhere?

## 4. Run the checks

Run what a contributor runs locally, in this order, and actually read the
output: formatter, linter, type checker, then the tests. Use the repo's own
commands, not a guess.

Everything must be green before the push. If something is red and you are
pushing anyway, that is a decision to state explicitly, not a detail to leave in
the scroll.

## 5. Report

Tell the user, in plain words: what changed, what you ran and what it said, and
anything you found and deliberately left alone. If the diff contains something
you are not sure about, say which part — that sentence is worth more than the
rest of the summary.
