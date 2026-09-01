---
description: Explain in plain words what something does or what just changed
argument-hint: [a file, a feature, a concept — or nothing for the current change]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

Explain this to me in plain words, as if I were directing the project without
reading the code — because I am.

Target: $ARGUMENTS

If nothing is named above, explain the change currently in progress:

- Status: !`git status --short`
- Diff stat: !`git diff --stat HEAD`
- Recent commits: !`git log --oneline -10`

Read the real code before answering — never explain from a filename or a guess.

Give me: what it does and why it exists, how it fits with the rest, what would
break if it were wrong, and anything about it that looks fragile or surprising.
No code in the answer. Name files and commands when I need them, and say what
you did not read.
