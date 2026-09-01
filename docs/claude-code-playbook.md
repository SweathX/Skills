# Getting the most out of Claude Code

The features that actually change how much you get done, roughly in the order
they are worth learning.

## Context is the whole game

Claude sees a limited window. Everything below is, in some form, about spending
it on the right things.

- **`/clear` between unrelated tasks.** A session carrying an hour of a finished
  debugging session into a new feature is a session making worse decisions. Free
  and instant — use it constantly.
- **`/context`** shows what is currently taking up the window. Worth a look when
  answers start feeling vague.
- **One task per session.** It is not a chat you keep forever. It is a workspace
  you open and close.
- **Point at the thing.** `@path/to/file` puts a specific file in front of
  Claude instead of leaving it to search. Precision beats volume every time.

## CLAUDE.md — the memory that persists

A `CLAUDE.md` at the root of a project is loaded into every session there. It is
where standing rules live: the stack, how to run and test, the conventions, the
traps.

- Write the **why and the principles**, not the file tree. A CLAUDE.md that
  lists directories is stale after the first refactor and then actively
  misleading.
- **`@~/Skills/fragments/general.md`** style imports pull in shared fragments, so
  standards live in one place across every project (that is what this repo is).
- **`#` at the start of a message** adds a rule to memory on the fly — the
  fastest way to record something you just had to say twice.
- A user-level `~/.claude/CLAUDE.md` holds preferences that follow you across
  every project.

## Plan mode — the single highest-value habit

**Shift+Tab** cycles the permission modes, one of which is plan mode: Claude
investigates and proposes, but changes nothing until you approve.

Use it for anything you cannot describe in one sentence. Reading the plan takes
a minute and catches the wrong approach before it is code — which is the
cheapest possible moment to catch it. It is also the only review step that works
when you do not read code.

The other modes matter too: the default asks before each action, and the
accept-edits mode stops asking for file edits. Turning off the prompts entirely
is a decision to take deliberately, in a sandbox, never on a repo that matters.

## Skills — repeatable know-how

A skill is a folder with a `SKILL.md`: a name, a description saying when to use
it, and the procedure. Claude loads it **automatically** when the description
matches what you are doing — you do not invoke it.

That auto-loading is why the description matters more than the body: it is the
only part Claude reads when deciding whether the skill applies. Write it as
*when* to use this, in the words you would actually use.

Skills are for procedures worth repeating exactly: how you debug, how you ship,
how your house style works. This repo installs its own at `~/.claude/skills/`,
so they apply in every project.

## Subagents — a second opinion and a clean context

A subagent runs a task in its own context window and reports back. Two reasons
to use one:

- **Isolation.** A big search or a long investigation would otherwise fill your
  session with files you will never need again. The subagent burns its own
  context and returns the conclusion.
- **Independence.** A reviewer that never saw the code being written finds
  things the author cannot. Never let the session that wrote a change be the
  only one that judges it — that is what `diff-reviewer` is for.

They are defined as markdown files with frontmatter (`~/.claude/agents/`), so
they carry a fixed role, a fixed model and a fixed tool set. This repo ships
three.

## Slash commands — your own shortcuts

A markdown file in `~/.claude/commands/` (or `.claude/commands/` in a project)
becomes `/name`. It can take arguments with `$ARGUMENTS`, run shell commands
whose output is injected before Claude reads the prompt, and restrict which
tools are allowed.

Anything you type more than twice a week should be one. This repo ships
`/skills:feature`, `/skills:review`, `/skills:pr` and `/skills:explain`.

Built-in ones worth knowing: `/clear`, `/context`, `/resume` to reopen a past
session, `/rewind` to roll back to an earlier checkpoint, `/init` to draft a
CLAUDE.md for a repo, `/config` for settings.

## Hooks — things that happen without asking

Hooks are shell commands the harness runs at fixed points: session start, before
a tool runs, after an edit, when Claude stops. They are configured in
`settings.json` and they execute deterministically — unlike an instruction in
CLAUDE.md, which is a request Claude can fail to follow.

Use them for the things that must always happen: formatting after an edit,
blocking a dangerous command, syncing a shared config at session start (this
repo's install hook is exactly that).

## MCP — connecting the outside world

MCP servers give Claude tools beyond the filesystem: GitHub, a database,
Sentry, Linear, a browser. Add the ones you actually use daily and no more —
every connected server spends context on tool definitions before you have typed
anything.

## Parallel work

Two sessions must never write the same checkout. When you want to run two pieces
of work at once, give each a **git worktree** of its own — a second working
directory on a second branch, sharing the same repository. Created beside the
repo, never inside it.

## Habits that compound

- **Plan mode for anything non-trivial.** The one habit to keep if you keep only
  one.
- **`/clear` between tasks.** The second one.
- **Correct the standing rules, not the session.** When you find yourself
  repeating an instruction, it belongs in CLAUDE.md or in a skill. Fixing it
  once fixes it everywhere, forever.
- **Ask for the evidence.** What did you run, what did it print, what did you
  not check.
- **Let it read before it writes.** Most bad output comes from a session that
  guessed at code it never opened. "Read X and Y first, then propose" costs
  thirty seconds and changes the answer.
