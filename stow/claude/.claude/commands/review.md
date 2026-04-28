---
description: Lokalni code review (pre-PR)
argument-hint: "[base-branch]"
---

Review proti: ${ARGUMENTS:-main}

## Postopek

1. Scope:
   - `git diff ${ARGUMENTS:-main}...HEAD --stat`

2. File-level analiza:
   - `git diff ${ARGUMENTS:-main}...HEAD -- <file>`

3. Preveri sistematično:

   **Correctness**
   - edge cases
   - null/undefined
   - race conditions

   **Security**
   - input validation
   - injection vectors
   - secrets v diff-u

   **Tests**
   - pokritost novega behaviorja
   - manjkajoči testi

   **Consistency**
   - skladnost s CLAUDE.md
   - naming / struktura

   **Performance**
   - N+1
   - nepotrebni sync calls
   - hot paths

---

## Output

- 🔴 **Blockers** — mora se popraviti
- 🟡 **Strong recommendations**
- 🟢 **Nice to have**

Pravila:
- Brez popravljanja kode.
- Brez praise.
- Če je OK → `LGTM` + konkreten razlog.
