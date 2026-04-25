---
description: Lokalni code review pred PR
argument-hint: "[base-branch]"
---

Naredi review sprememb proti ${ARGUMENTS:-main}.

Postopek:
1. `git diff ${ARGUMENTS:-main}...HEAD --stat` — kaj se je spremenilo
2. Za vsak file: `git diff ${ARGUMENTS:-main}...HEAD -- <file>`
3. Preveri:
   - Bugge: edge case-i, null, race conditions
   - Security: input validation, injection, secrets v diff-u
   - Testi: novi behavior pokrit?
   - Konvencije: sledi CLAUDE.md projekta?
   - Performance: N+1, sync v hot pathu

Output:
- 🔴 **Blokerji** (mora se popraviti)
- 🟡 **Strong recommendations**
- 🟢 **Nice to have**

Bodi direkten. Ne hvali za hvaljenje. Če je vse OK, reci "LGTM" + razlog.
NE popravljaj sam — samo poročaj.
