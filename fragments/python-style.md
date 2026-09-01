## Python Style

Import into any repo whose main language is Python.

### Types and boundaries (CRUCIAL)

- **Annotate every function signature** — parameters and return. Types inside a
  body are optional; on a signature they are the documentation that cannot rot.
- Validate data coming from outside the program at the boundary — an HTTP body,
  a config file, a CSV, an environment variable — with `pydantic` or whatever
  the repo already uses. Inside the boundary, types are trusted; outside, they
  are claims.
- Prefer precise types over `Any` and over bare containers: `list[Order]`, not
  `list`. `Any` in a signature is a hole in every caller.
- Use `dataclass` (or a pydantic model) rather than passing dicts around. A dict
  with known keys is a class that lost its name.

### Structure

- Modules named for what they contain, small and single-purpose. A `utils.py`
  that keeps growing is a design that was never made.
- No logic at import time beyond definitions and constants: no I/O, no network,
  no side effects. `if __name__ == "__main__":` for entry points.
- Never mutate a default argument — `def f(items: list[str] | None = None)`,
  then default inside.
- Prefer pure functions with explicit arguments over module-level state.
  Global mutable state is what makes tests order-dependent.

### Errors

- Raise specific exceptions, ideally the project's own type deriving from
  `Exception`, so callers can catch what they mean.
- Never `except Exception: pass`, and never a bare `except:`. Catch the
  exception you can act on; let the rest travel.
- Use `raise ... from err` when re-raising, so the original traceback survives.
- Context managers (`with`) for anything that must be released — files,
  connections, locks, temporary directories.

### Environment and dependencies

- Always a virtual environment; never install into the system interpreter.
- Follow the repo's existing tool (`uv`, `poetry`, `pip-tools`, plain
  `requirements.txt`) rather than introducing a second one. Dependencies are
  pinned in whatever lockfile the repo already has, and lockfile changes are
  called out in the PR body.

### Tooling

- `ruff` (lint + format) and a type checker (`mypy` or `pyright`) if the repo
  has them; run them before committing.
- Never add a blanket `# type: ignore` or `# noqa` to make a check pass. If a
  suppression is genuinely right, it names the specific rule and says why in a
  comment.

### Performance, only when it matters

Write the clear version first. Reach for a comprehension over a loop when it
reads better, not because it is faster. Optimise after measuring, and say what
you measured.
