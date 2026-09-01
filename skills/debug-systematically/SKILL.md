---
name: debug-systematically
description: Find the actual cause of a bug instead of guessing at fixes. Use whenever something is broken, a test is failing, an error or stack trace appears, behaviour is wrong or unexplained, a fix did not work, or the user says something like "it does not work", "this is broken", "why is this happening", or reports a crash.
---

# Debug systematically

Guessing produces a fix that makes the symptom go away and leaves the cause in
place. This is the loop that does not.

## Rule zero

**Never change code you do not understand.** If you cannot say why the bug
happens, you are not ready to fix it — you are ready to keep investigating.

And never "fix" it by removing the check that reported it: deleting an
assertion, widening a `catch`, skipping a test or downgrading an error to a
warning is not a fix, it is turning off the alarm.

## The loop

### 1. Reproduce it

Get a command, a request or a click path that fails on demand, and run it. A bug
you cannot reproduce is a bug you cannot confirm you fixed.

If it is intermittent, say so out loud and hunt the difference between the runs:
timing, ordering, leftover state, concurrency, cache, a clock, a random seed.

### 2. Read the actual error

The whole message, the whole stack trace, the deepest frame that is your code.
Not the summary line. Most bugs are named in the output and never read.

Check what changed: `git log` on the failing area, the last deploy, a dependency
bump. A bug that "appeared on its own" usually appeared with a commit.

### 3. Narrow it down

Cut the search space in half at each step rather than reading everything:

- Where is the data still correct, and where is it already wrong? Log or inspect
  at the midpoint between those two.
- Does it fail with the smallest possible input? Strip until it stops failing —
  what you removed last is where to look.
- Does it fail on an older commit? `git bisect` when the history is clean.

### 4. State the cause

Write one sentence: *"X happens because Y."* If you cannot, keep narrowing.

Then check the sentence explains **everything you observed**, including the
parts that seemed irrelevant. A cause that explains the crash but not why it
only happens on Mondays is half a cause, and the other half is another bug.

### 5. Fix the cause

Fix where the bug is, not where it surfaced. A null check at the call site when
the real problem is a function that returns null for a case it should handle
just moves the crash.

Keep the fix minimal and separate: fixing the bug and refactoring the module are
two commits, and mixing them hides the fix.

### 6. Prove it

- The reproduction from step 1 now passes.
- **A test that fails before the fix and passes after it.** Write it, confirm it
  goes red on the unfixed code, then keep it. This is what stops the bug coming
  back in six months.
- The rest of the suite still passes. Run it — a fix that breaks two other
  things is not done.

### 7. Look next door

The same mistake is rarely made once. Search for the pattern elsewhere in the
codebase and report what you find, fixed or not.

## Reporting

Say what the cause was in plain words, what you changed, and what you ran to
prove it. If the cause is still unknown and you applied a workaround, say
exactly that — a workaround presented as a fix is how the same bug gets closed
three times.
