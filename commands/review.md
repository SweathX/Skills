---
description: Review the current change before it goes out
argument-hint: [optional: what to focus on]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
---

Review the change currently in progress before it goes anywhere.

Current state:

- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Committed on this branch: !`git log --oneline origin/HEAD..HEAD 2>/dev/null | head -20`
- Diff stat: !`git diff --stat HEAD`

Run the `review-before-push` skill over it, then dispatch the `diff-reviewer`
agent on the full change for a second, independent pass. Report both: what you
found yourself, and what the reviewer found.

Do not fix anything yet — tell me what is there first, ordered by how much it
matters, and I will say what to fix.

$ARGUMENTS
