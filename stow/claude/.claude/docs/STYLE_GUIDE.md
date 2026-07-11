# Style Guide

A practical guide to writing clean, professional, maintainable code in this
project. It is language-agnostic in its principles, with concrete rules where
specificity matters. When a language's official style guide (PEP 8, the Google
style guides, Effective Go, the Rust API guidelines, etc.) is stricter than this
document, follow the stricter rule.

---

## 1. Guiding principles

1. **Readability is the primary feature.** Code is read far more often than it is
   written. Optimize for the person debugging it at 2 a.m., not for keystrokes saved.
2. **Least surprise.** A reader should be able to predict what a function does from
   its name and signature without reading the body.
3. **One reason to change.** Each unit of code (function, class, module) should have
   a single, well-defined responsibility.
4. **Make the implicit explicit.** Prefer clear, verbose intent over clever, terse tricks.
5. **Delete before you add.** The best code is no code. Remove before you extend.

---

## 2. Functions

Functions are the unit where most clarity is won or lost.

### Size and scope

- **Do one thing.** A function should do one thing, do it well, and do it only.
- **Keep them short.** Aim for functions that fit on one screen (roughly ≤ 40 lines).
  If you need to scroll, it is probably two functions.
- **One level of abstraction per function.** Don't mix high-level orchestration with
  low-level string manipulation in the same body. Extract the low-level part.

### Arguments

- **Prefer fewer arguments.** Zero, one, or two is ideal. Three is a warning. Four or
  more almost always means the arguments want to be an object/struct.
- **No boolean flag arguments** that switch behavior (`render(true)`). Split into two
  clearly named functions (`renderVisible()` / `renderHidden()`) or pass an enum.
- **No output arguments.** A function communicates its result through its return value,
  not by mutating a parameter.

### Return values and control flow

- **Return early.** Guard clauses at the top beat deeply nested `if/else` pyramids.

  ```python
  # Avoid
  def process(order):
      if order is not None:
          if order.is_paid:
              # ... real work deeply nested ...

  # Prefer
  def process(order):
      if order is None:
          raise ValueError("order is required")
      if not order.is_paid:
          return
      # ... real work at the top level ...
  ```

- **Avoid returning `null`/`None` for "not found" when a caller will forget to check.**
  Prefer an explicit optional type, a raised exception, or an empty collection.
- **No surprising side effects.** A function named `is_valid()` must not also mutate state.

### Purity and side effects

- Separate **decisions** (pure logic, easy to test) from **actions** (I/O, mutation).
  Keep side effects at the edges; keep the core pure.
- A function should either **do something** (a command) or **answer something**
  (a query) — not both. This is the Command–Query Separation principle.

---

## 3. Comments

- **Prefer self-documenting code over comments.** If you need a comment to explain
  *what* the code does, first try to rewrite the code so the comment is unnecessary.
- **Comment the *why*, not the *what*.** Explain intent, trade-offs, and non-obvious
  constraints — the things the code itself cannot say.

  ```js
  // Good: explains a non-obvious reason
  // Stripe rounds to 2 decimals; we pre-round to avoid off-by-one refund errors.
  const amount = roundToCents(rawAmount);
  ```

- **Delete commented-out code.** Version control is the archive. Dead code in the file
  is noise and a lie about what runs.
- **Keep comments truthful.** An outdated comment is worse than no comment. Update
  comments in the same change that updates the code.
- Use structured doc comments (JSDoc, docstrings, `///`) for public APIs — parameters,
  return values, raised errors, and one example where it helps.

---

## 4. Formatting

Formatting is not a matter of taste in this project; it is automated.

- **Use the project formatter and never fight it.** Prettier, Black/Ruff, gofmt,
  rustfmt — whatever the language mandates. CI enforces it.
- **One statement per line.** No chained side effects crammed onto a single line.
- **Consistent indentation** per the language default (2 spaces for JS/TS, 4 for Python).
- **Line length:** follow the formatter's default (e.g. 88 for Black, 80–100 for JS/TS).
  Don't hand-wrap what the formatter will wrap.
- **Vertical spacing carries meaning.** Group related lines; separate distinct steps
  with a single blank line. Never leave more than one consecutive blank line.
- **Imports** are grouped and ordered: standard library, then third-party, then local —
  each group separated by a blank line, alphabetized within groups. Let the tooling sort.
- **No trailing whitespace; files end with a single newline.**

---

## 5. Error handling

- **Validate at the boundary.** Check inputs where untrusted data enters the system
  (API handlers, CLI parsing, file reads). Trust it internally.
- **Fail fast and loudly.** Raise/throw a specific, typed error with a message that
  says what was expected and what was received.
- **Never swallow errors silently.**

  ```python
  # Forbidden
  try:
      do_work()
  except Exception:
      pass
  ```

  If you catch, you must handle: recover, translate to a domain error, log with context,
  or re-raise. An empty `except`/`catch` is a bug.
- **Use exceptions for exceptional cases, not control flow.** Expected outcomes
  (a missing cache key, an empty result) are return values, not exceptions.
- **Preserve context.** When wrapping an error, chain the original (`raise ... from err`,
  `%w` in Go, `.cause` in JS). Never discard the stack trace.
- **Clean up deterministically.** Use `finally`, context managers (`with`), `defer`,
  or RAII so resources are always released.

---

## 6. Immutability and state

- **Prefer immutability.** Default to `const`/`final`/`val`; reach for mutable state only
  when there is a reason.
- **Avoid shared mutable state.** It is the root of most concurrency and reasoning bugs.
- **Don't mutate function arguments** unless the mutation is the documented purpose.
- **Keep scope tight.** Declare variables as close to first use as possible; never reuse
  one variable for two unrelated purposes.

---

## 7. Testing

- **Every behavior change ships with tests.** A test that would pass before your change
  proves nothing about your change.
- **Test names describe behavior**, not implementation:
  `returns_empty_list_when_no_matches`, not `test_search_2`.
- **Arrange–Act–Assert.** One logical assertion per test where practical.
- **Test behavior, not internals.** Assert on observable outputs and effects, not private
  fields, so tests survive refactors.
- **Cover the edges:** empty inputs, boundaries, error paths, and the null/None case —
  not just the happy path.
- **Tests are code.** They get the same naming, formatting, and clarity standards as
  production code. No copy-pasted, mystery-constant test bodies.

---

## 8. Dependencies and imports

- **Add dependencies deliberately.** Every dependency is a liability (security, upgrades,
  bundle size). Prefer the standard library; justify each third-party addition.
- **Depend on abstractions, not concretions** at module boundaries so implementations
  can be swapped and tested.
- **No circular dependencies.** If module A needs B and B needs A, the responsibility
  split is wrong — extract the shared piece.

---

## 9. Security hygiene (baseline)

- **No secrets in source.** API keys, tokens, and passwords come from environment
  variables or a secrets manager — never string literals or committed config.
- **Never log sensitive data** (passwords, tokens, PII, full card numbers).
- **Treat all external input as hostile.** Validate and sanitize; use parameterized
  queries; never build SQL or shell commands by string concatenation.
- **Least privilege.** Request only the permissions, scopes, and access a component needs.

---

## 10. Quick reference

| Do                                              | Don't                                         |
| ----------------------------------------------- | --------------------------------------------- |
| Small functions that do one thing               | God functions that do everything              |
| Descriptive, intention-revealing names          | `data`, `tmp`, `obj`, `x`, `handle2`          |
| Guard clauses / early returns                   | Deeply nested `if/else` pyramids              |
| Explain *why* in comments                       | Narrate *what* the code already says          |
| Handle or re-raise errors with context          | Empty `catch` / bare `except: pass`           |
| Immutable by default                            | Shared mutable state everywhere               |
| Tests for every behavior change                 | "I'll add tests later"                        |
| Let the formatter decide layout                 | Hand-tuned, inconsistent whitespace           |
| Config/secrets from environment                 | Hardcoded credentials                         |
