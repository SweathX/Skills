# Vibe coding, honestly

Vibe coding means directing a project you do not read the code of. It works —
people ship real software this way. It also fails in a specific, predictable
way, and everything below is about staying on the first side of that line.

The core problem is simple: **you cannot verify by reading, so you must verify
by other means.** Every habit here exists to replace the review you are not
doing.

## The five habits that decide everything

### 1. Say what you want, not how to build it

Describe the outcome, the user, the constraints. Leave the implementation to
Claude — that is the part you are delegating. But be specific about the outcome:
"a page where I can see my orders" builds something; "a page listing my orders
newest first, with the status and the total, and a message when there are none"
builds the right thing.

The rule of thumb: if two competent people could read your request and build
different things, it is not a request yet.

### 2. Small steps, always verified

One capability at a time, checked before the next one starts. A session that
builds six things and then discovers the second one was wrong has to unpick all
six.

Verification for you is not reading the diff. It is: **run it and look.** Open
the page, call the endpoint, click the button. If you cannot try it yourself,
ask for the command that proves it works, and run that.

### 3. Make Claude prove things, not claim them

"It works now" is not evidence. The three questions that catch most of it:

- *What did you run, and what exactly did it print?*
- *Is there a test that fails without this change?*
- *What did you not check?*

A model that has to answer those stops rounding a partial result up to a
success. Ask them routinely, not only when you are suspicious.

### 4. Commit constantly

Git is your undo button, and it is the only one you have. Commit every time
something works, before starting the next thing. A branch per piece of work.

The worst position in vibe coding is: it worked an hour ago, four things changed
since, and nothing is committed. Commit early and you can always go back to the
last good state instead of debugging a mess you cannot see.

### 5. Never accept "I fixed it" for something that was broken twice

When the same bug comes back, stop adding fixes. Ask for the cause in one
sentence — *"X happens because Y"* — and do not let the work continue until that
sentence exists. Repeated fixes to the same symptom mean nobody has found the
cause, and each one adds code that will have to be removed later.

## What to watch for

These are the failure patterns that actually cost time.

**Silent scope creep.** You asked for one thing and got that plus a refactor of
two other files. It looks like generosity; it is unreviewable risk. Say when you
notice it, and ask for changes outside the task to be reported instead of made.

**The disabled alarm.** A test was failing, so it got skipped. An error was
noisy, so it got caught and logged. A type complained, so it got silenced. Each
is a fix that removes the thing that would have told you about the next bug. Ask
directly: *did you disable, skip or weaken anything to get this green?*

**The confident summary over a broken state.** The most expensive failure mode,
because nobody is reading the code to catch it. This is why habit 3 exists.

**Growing without shape.** After a few weeks, a vibe-coded project becomes hard
to change — not because the code is bad, but because the same logic now exists
in five places. Ask periodically: *is there duplicated logic we should pull
together?* Then do it, in its own change, with everything working before and
after.

**Secrets in the repo.** An API key ends up in a committed file and it is on
GitHub forever, even if the next commit removes it. Say once, at the start of
every project, that keys live in `.env` and `.env` is git-ignored. Then check
that it is.

## What to keep in the project itself

Two files pay for themselves within a week:

- **`CLAUDE.md`** — the standing rules for the project: what it is, what it
  depends on, how to run and test it, the conventions to follow, the traps. It
  is loaded into every session automatically, so anything you find yourself
  saying twice belongs there. Import the shared fragments at the top of it
  instead of restating standards.
- **`docs/specs/` and `docs/plans/`** — for anything bigger than an afternoon.
  The spec is what you approved; the plan is how it gets built. They are what
  makes a feature resumable next week, by a session with no memory of this one.

## Where vibe coding stops

Be honest about the boundary. Directing without reading is fine for most product
work. It is not fine, alone, for: anything handling money, anything storing
personal data, authentication and permissions, and anything irreversible like a
migration that rewrites existing data.

That does not mean do not build it. It means: for those parts, get a second pass
— the `diff-reviewer` agent at minimum, a human who reads code when the stakes
are real. The cost of being wrong there is not a bug, it is an incident.
