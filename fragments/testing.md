## Testing

### What a test is for

A test exists to catch a regression that would otherwise reach production. That
is the only bar. A test that restates the implementation line by line catches
nothing and breaks at every refactor — it costs more than the bug it never
finds.

Test the **behaviour at the boundary of a unit**: given these inputs and this
state, this is what comes out and this is what changed. Not the private steps
in between.

### What to cover, in order

1. **The happy path** of anything a user can reach.
2. **The edges that actually happen**: empty, one, many, missing field, wrong
   type, unauthorised, timeout, duplicate submission.
3. **Every bug you fix.** A fix without a test that fails before it is a fix
   that will be made twice. This is the single highest-value test in the repo.

Skip: getters, framework behaviour, third-party libraries, and anything whose
failure the type system already prevents.

### Rules

- **A test must be able to fail.** After writing one, confirm it fails against
  the unfixed code or a deliberately broken version. A green test that was never
  seen red proves nothing.
- **Never change a test to make it pass** unless the specification genuinely
  changed — and say so explicitly when you do. A failing test is a message.
- **Never skip, comment out, delete or weaken a failing test** to get a green
  run. If a test is wrong, fix it and explain why in the commit body; if it is
  flaky, fix the flakiness or say plainly that it is unresolved.
- **No network, no clock, no randomness** in a unit test. Inject them. A test
  that depends on the current time fails on a Tuesday six months from now.
- **Independent and order-free.** No shared mutable state between tests, no
  reliance on execution order.
- Name a test for the behaviour it pins down, so a failure names the bug in the
  report: `rejects_expired_token`, not `test_auth_2`.
- Mock what you do not own (external APIs, payment providers). Do not mock your
  own code to avoid designing it — needing five mocks for one function is the
  function telling you it does too much.

### Reporting

Always say what you ran and what came back. "The suite passes" means the suite
was run just now, in full, and it passed. If only part of it ran, say which
part. If something is red, say which test and what it says — never summarise a
red run as done.
