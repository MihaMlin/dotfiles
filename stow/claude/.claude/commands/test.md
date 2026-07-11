---
description: Write or improve tests for the specified code, following project standards
---

Write (or improve) tests for the code I specify, following the testing standards in
`@docs/STYLE_GUIDE.md` §7.

Requirements:

- **Cover behavior, not internals** — assert on observable outputs and effects so the
  tests survive refactors.
- **Cover the edges:** empty inputs, boundaries, invalid input, and error paths — not
  only the happy path.
- **Name each test for the behavior it verifies**, e.g. `returns_empty_when_no_match`.
- Use **Arrange–Act–Assert** structure with one logical assertion per test where practical.
- Keep tests **deterministic** — no reliance on real time, network, randomness, or
  ordering. Inject or fake those.
- Treat test code as production code: same naming, formatting, and clarity standards.

First, tell me which behaviors you'll cover and any gaps you notice in the current
tests. Then write them using this project's existing test framework and conventions
(check neighboring test files first).
