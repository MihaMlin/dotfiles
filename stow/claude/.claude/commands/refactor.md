---
description: Refactor the specified code to meet clean-code and architecture standards
---

Refactor the code I point you to so it conforms to this project's standards in
`.claude/docs/` — without changing its observable behavior.

Rules for this refactor:

- **Behavior must not change.** If tests exist, they must still pass. If they don't
  exist, note what tests should be added to lock behavior before/after.
- Apply the **Style Guide** and **Naming Conventions**: small single-purpose functions,
  intention-revealing names, early returns, no dead code.
- Respect the **Architecture Principles**: correct layering, no new circular
  dependencies, side effects at the edges.
- Make **small, reviewable steps**, not one giant rewrite. Prefer a sequence of
  safe transformations.

Before editing, give me a short plan: what you'll change and why. After I confirm,
apply the changes and summarize what improved (readability, coupling, testability),
citing the specific standards you applied.
