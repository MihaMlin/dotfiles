---
description: Review the current changes against the project's code standards
---

Review the code in the current diff (or the files I specify) against this project's
standards.

Invoke the `reviewing-code` skill and work through its checklist, applying the
`writing-clean-code`, `naming-things`, and `structuring-architecture` skills.

Produce your review in this structure:

1. **Summary** — one or two sentences on overall quality and readiness to merge.
2. **Blockers** — issues that must be fixed before merge (correctness, security,
   broken standards). Cite the specific rule.
3. **Suggestions** — improvements worth making but not blocking.
4. **Nits** — minor, optional polish.

For each item, reference the file and line, explain *why* it matters, and show a
concrete fix. Be specific and constructive. If the change is clean, say so plainly
rather than inventing problems.
