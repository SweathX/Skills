---
description: Spec, plan and build a feature through the full flow
argument-hint: [what you want to build]
---

Build this feature: $ARGUMENTS

Use the `plan-feature` skill and follow it in order. In particular:

- Read the code the feature touches before writing anything.
- Ask me, in one batched message, only the questions whose answers change what
  gets built.
- Show me the spec summary and **wait for my approval** before any code.
- Once the plan is written, dispatch the `plan-reviewer` agent on the spec and
  the plan together, and fix what it finds before starting.
- Build one batch at a time, committing per task, and tell me in one sentence
  what landed after each.
- When everything has landed, dispatch the `diff-reviewer` agent, apply what it
  tags `fix`, bring me what it tags `owner`, then dispatch it once more.
