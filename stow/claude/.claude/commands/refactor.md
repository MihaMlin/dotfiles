---
description: Sistemski refaktor z determinističnim planom
argument-hint: "<scope + razlog>"
---

Refaktor: $ARGUMENTS

## Phase 1 — Analiza & Plan (NO CODE)

1. Analiziraj obstoječo implementacijo:
   - kompleksnost
   - podvajanje (DRY)
   - coupling / cohesion
   - type safety
   - readability

2. Ustvari/posodobi `plan.md`:

   **Cilj**
   - merljiv razlog (npr. ↓ cyclomatic complexity, ↑ type safety)

   **Obseg**
   - točne datoteke / funkcije

   **Spremembe**
   - konkretni posegi (rename, extract, split, replace…)

   **Invarianti (Behavior Lock)**
   - kaj se NE sme spremeniti

   **Verifikacija**
   - kateri testi / checks garantirajo enak behavior

   **Tveganja**
   - kje lahko pride do regresije

3. STOP:
   - izpiši kratek plan (brez kode)
   - čakaj na **GO**

---

## Phase 2 — Execution (AFTER GO)

1. Implementiraj v atomarnih korakih.
2. Po vsakem koraku:
   - build / lint / testi
3. Prepovedano:
   - novi feature-ji
   - nepovezani bugfixi

4. Pred zaključkom:
   - preveri `git diff`
   - odstrani debug artefakte

---

Output:
- Pred GO → samo plan
- Po GO → implementacija
- Na koncu → `ready to commit?` + `refactor:` commit message

Constraint:
- Če plan postane neveljaven → STOP → nazaj v Phase 1
