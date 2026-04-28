---
description: Local code review (pre-PR)
argument-hint: "[base-branch]"
---

Review against: ${ARGUMENTS:-main}

## Process

1. Scope:
   - `git diff ${ARGUMENTS:-main}...HEAD --stat`

2. File-level analysis:
   - `git diff ${ARGUMENTS:-main}...HEAD -- <file>`

3. Check systematically:

   **Correctness**
   - edge cases
   - null/undefined
   - race conditions

   **Security**
   - input validation
   - injection vectors
   - secrets in the diff

   **Tests**
   - coverage for new behavior
   - missing tests

   **Consistency**
   - alignment with CLAUDE.md
   - naming / structure

   **Performance**
   - N+1
   - unnecessary sync calls
   - hot paths

---

## Output

- 🔴 **Blockers** — must be fixed
- 🟡 **Strong recommendations**
- 🟢 **Nice to have**

Rules:
- Do not modify code.
- No praise.
- If it is OK → `LGTM` + a concrete reason.
