---
name: plan-feature
description: Turn a feature request into a short spec and a batched plan before writing any code, then get the spec approved. Use when the user asks to build, add or implement something that gives a capability that does not exist yet, when a request is vague enough that two people would build different things, or when they ask to plan a feature. Not for bug fixes, refactors, one-line changes or investigations.
---

# Plan a feature

Most of what goes wrong in a feature was decided before the first line of code:
the wrong thing got built, correctly. This skill spends fifteen minutes making
the decision explicit so the build is only execution.

## When to skip this

Ask one question: **would the spec and the plan tell anyone anything the diff
does not already say?**

If the answer is no and there is nothing to design — a flag, a copy change, a
field on a response, a small fix — write the code directly, on a branch, with
the usual commit and PR conventions. Say in one line that you are skipping this
and why.

Two things pull a small change back in anyway: it touches something later work
builds on (a schema, a stored format, an external API, a contract other code
assumes), or you cannot finish it without taking design decisions you did not
have when you started. The second one is discovered mid-change — stop and come
back here rather than deciding alone inside a diff nobody planned.

## The steps

### 1. Understand before proposing

Read the code the feature touches. Never write a spec from the request alone:
half the design decisions are already made by the existing code, and a spec that
contradicts how the system works is a plan to rewrite it by accident.

Ask the user about anything that would change what gets built — and only that.
Batch the questions into one message; do not interview them one question at a
time. Guess the rest and state the guess.

### 2. Write the spec

Short, in the user's language, in `docs/specs/<date>-<feature>.md`:

- **Problem** — what is wrong or missing today, in two or three sentences.
- **What the user gets** — the observable behaviour, from outside. Screens,
  commands, endpoints, outputs. No implementation.
- **Out of scope** — what this deliberately does not do. This section prevents
  more rework than the rest of the document combined.
- **Open questions** — anything still undecided, with your recommendation.

If the spec is longer than the diff will be, the feature did not need a spec.

### 3. Get the spec approved (mandatory)

Summarise it in a few sentences to the user and **wait**. This is the one point
where a human seals the scope. Nothing is built until they accept it.

Once approved, the spec is the scope. After that, nothing is added to what the
feature does and nothing about its behaviour changes without going back to them.

### 4. Write the plan

In `docs/plans/<date>-<feature>.md`, as ordered **batches of one to five
tasks**:

- One task is one commit, and one batch is a coherent unit that can be built and
  verified on its own.
- **Every batch ends with an integration task**: the wiring that makes the
  batch's code actually reachable, or the tests that exercise it when the batch
  delivers foundations something later consumes. Never neither — that is what
  stops a batch landing code nothing calls.
- Mark the batches the rest of the feature builds on. A wrong data model, a
  wrong error contract or a wrong migration is not caught by the batch that
  consumes it; it is caught at the end, with everything already standing on it.
  Those get reviewed before the next batch starts. At most two per feature — if
  more qualify, the batching is wrong.
- Name the files each task touches. A plan that says "update the backend" is a
  wish.

### 5. Build it

One batch at a time, in order, committing per task. After each batch: run the
checks, push, tick the batch in the PR body, then start the next one. Never run
two batches at once against the same checkout.

Between batches, tell the user in one sentence what just landed.

When a batch turns out to be impossible as planned, stop and fix the plan — do
not improvise around it and leave the plan lying. If the fix changes what the
user gets, it is the spec, and the spec belongs to them.

### 6. Review before it goes out

Once every batch has landed, review the whole diff as one thing — cross-batch
coherence, coverage of the spec, whatever drifted along the way. Dispatch the
`diff-reviewer` agent for it if it is available, then fix what it finds and
review again. Never grade your own fix in the same pass that wrote it.
