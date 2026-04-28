---
description: Systematic refactor with a deterministic plan
argument-hint: "<scope + reason>"
---

Refactor: $ARGUMENTS

## Phase 1 — Analysis & Plan (NO CODE)

1. Analyze the existing implementation:
   - kompleksnost
   - duplication (DRY)
   - coupling / cohesion
   - type safety
   - readability

2. Create/update `plan.md`:

   **Goal**
   - measurable reason (e.g. ↓ cyclomatic complexity, ↑ type safety)

   **Scope**
   - exact files / functions

   **Changes**
   - concrete operations (rename, extract, split, replace...)

   **Invariants (Behavior Lock)**
   - what must NOT change

   **Verification**
   - which tests / checks guarantee the same behavior

   **Risks**
   - where regressions may occur

3. STOP:
   - print a short plan (no code)
   - wait for **GO**

---

## Phase 2 — Execution (AFTER GO)

1. Implement in atomic steps.
2. After each step:
   - build / lint / tests
3. Forbidden:
   - new features
   - unrelated bug fixes

4. Before finishing:
   - check `git diff`
   - remove debug artifacts

Output:
- Before GO → plan only
- After GO → implementation
- At the end → `ready to commit?` + `refactor:` commit message

Constraint:
- If the plan becomes invalid → STOP → back to Phase 1
