## TypeScript / JavaScript Style

Import into any repo whose main language is TypeScript or JavaScript, on the
front end or on Node.

### Types are the design (CRUCIAL)

- **`any` is a bug.** When a type is genuinely unknown, use `unknown` and narrow
  it. When it comes from outside the program — an HTTP body, a form, a webhook,
  a JSON file, `localStorage` — parse it at the boundary with a schema (`zod` or
  whatever the repo already uses) and let the parsed type flow inward. A cast is
  not validation: `as User` on a network response is a lie the compiler believes.
- **Never silence the compiler.** No `@ts-ignore`, no `!` non-null assertion to
  make an error go away. If one is truly unavoidable, `@ts-expect-error` with a
  comment saying why, so it fails the day it stops being needed.
- **Make illegal states unrepresentable.** A discriminated union beats an object
  with four optional fields and a comment explaining which combinations are
  real.
- Prefer `type` for unions and object shapes, `interface` when a public contract
  is meant to be extended. Do not mix both for the same thing in one repo.

### Structure

- Small modules with one clear responsibility, named for what they do. Avoid
  `utils.ts` growing into a landfill — a helper used in one place belongs beside
  its caller.
- Export what callers need. A module exporting everything it defines has no API.
- Named exports by default; a default export only where a framework requires it
  (a Next.js page or route, for example).
- No barrel `index.ts` re-exporting a whole directory unless the repo already
  works that way — they wreck tree-shaking and create import cycles.

### Async and errors

- `async`/`await` everywhere; no floating promises. Every promise is awaited,
  returned, or explicitly handled.
- Independent async calls run with `Promise.all`, not one `await` after another.
- Catch an error only where you can do something about it — add context, retry,
  or turn it into a user-facing state. A `catch` that logs and continues turns a
  failure into silent corruption.
- Never swallow an error into an empty block. Never `catch (e) { console.log(e) }`
  as the whole handler in production code.
- Throw `Error` instances (or a subclass), never strings.

### React and Next.js

- Components describe what the UI *is* for a given state, not the steps to build
  it. If a component needs a comment to explain its phases, it is two components.
- `useEffect` is for synchronising with something outside React — a subscription,
  a timer, an imperative API. Deriving state from props, fetching on render, or
  keeping two pieces of state in sync are all signs the effect should not exist.
- Data fetching goes through the framework's own mechanism (server components,
  loaders, or the repo's query library). Hand-rolled `fetch` inside `useEffect`
  is the pattern that produces the loading-state bugs.
- Keys are stable ids, never array indices for a list that can reorder.
- Keep client bundles honest: `"use client"` at the smallest component that
  actually needs it, not at the top of a page.
- Accessibility is not a follow-up: real `<button>` for actions, labels tied to
  inputs, focus visible, images with `alt`.

### Node

- Read configuration once at startup, validate it there, and fail loudly on a
  missing variable rather than at the first request that needs it.
- Never build SQL or shell commands by string concatenation with user input.
- Every outbound HTTP call gets a timeout. A call without one hangs forever the
  day the other side does.

### Tooling

- The repo's existing linter and formatter are the law. Run them before
  committing; never disable a rule inline to make a commit pass — fix the code
  or change the rule in the config, deliberately.
- Lockfile changes are part of the diff and are mentioned in the PR body.
