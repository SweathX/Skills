---
description: Commit, push and open or update the pull request
argument-hint: [optional: what this PR is about]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
---

Get this work onto a branch and into a pull request.

Current state:

- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Diff stat: !`git diff --stat HEAD`

Follow the `ship-pr` skill: check the diff for anything that does not belong,
run the repo's checks, branch if we are still on the default branch, commit with
the house convention, push, then open the PR as a draft or update the existing
one.

Stop and tell me if a check fails or if the diff contains something I should see
before it is pushed. Never merge.

$ARGUMENTS
