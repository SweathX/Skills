---
name: ship-pr
description: Commit work on a proper branch and open or update a pull request with a body that reads well. Use when the user asks to commit, push, open a PR, ship, or when a piece of work is finished and needs to reach review.
---

# Ship it

## Before anything

Run `review-before-push` first, or its checks. Never open a PR on a diff you
have not read.

## Branch

Never commit on `main`. If the work is already sitting on `main` uncommitted,
create the branch now and commit there — the changes follow the checkout.

```
git fetch origin
git checkout -b type/kebab-description origin/main
```

`type` is one of `feat | fix | refactor | chore | docs | perf`.

## Commit

Stage the files the change touches — never `git add -A` blindly. One logical
change per commit; a commit that both fixes a bug and renames a module is two
commits.

Message: a title line saying the purpose, a blank line, then one prefixed line
per change (`[+]` added, `[&]` changed, `[!]` fixed, `[-]` removed). No footers.

## Push

```
git push -u origin <branch>
```

## The PR

Open it as a **draft** right after the first push, and keep it current after
every push afterwards. Body:

- **Why** — the problem or goal, one to three sentences. A reviewer who reads
  only this should know whether the change is worth their time.
- **Changes** — the prefixed list, grouped by area if it is long.
- **State** — a checklist when the work has several steps, ticked as each lands.
- **Deployment notes** — a new environment variable, a secret, a migration, a
  service ordering. This reaches the deployment through no other path, so it is
  never skipped when it applies.
- **Known issues** — anything found and deliberately left unfixed.

Check the repo for a PR template first and fill its sections instead if there is
one.

Editing a PR body replaces the whole document: only the session that owns the PR
writes it.

## Then

Mark it ready for review once the work is complete and CI is green. If CI goes
red, that is work now — read the failing job's actual log rather than guessing,
fix it, and push. "Probably a flake" is a conclusion you reach after re-running
once, never a first explanation.

Never merge the PR unless the user explicitly asks.
