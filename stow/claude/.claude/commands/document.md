---
description: Add clear, standards-compliant documentation to the specified code
---

Document the code I specify following the commenting standards in `@docs/STYLE_GUIDE.md`
§3.

Guidelines:

- **Document the *why*, not the *what*.** Don't narrate what the code obviously does;
  capture intent, trade-offs, and non-obvious constraints.
- Add **structured doc comments** (JSDoc / docstrings / `///`) to public APIs: describe
  parameters, return values, raised errors, and include one short example where it helps.
- **Do not add comments to compensate for unclear code.** If a comment is needed to
  explain confusing logic, first propose renaming or restructuring so the comment
  becomes unnecessary — then tell me.
- Keep any prose accurate and concise. Remove stale or misleading comments you find.

If a README, module header, or usage doc should be updated to match the change, note
that and offer to update it.
