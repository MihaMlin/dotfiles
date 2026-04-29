# CLAUDE.md — Global Operating System

## Core Principle
Maximal correctness with minimal assumptions. Every step must be justified, reproducible, and reversible.

---

## The Three-Step Workflow (MANDATORY)
When using superpowers follow the 3 step plan, write the files to /docs/superpowers.

### Phase 1 — Brainstorming (WHAT)
Analyze the request and explore solution space.

**Output → `specs.md`**
Must include:
- Goal (precise, testable)
- Required functionality
- Constraints (technical, performance, security)
- Edge cases
- Non-goals

**Rules:**
- No code.
- No implementation details.
- No file changes except `specs.md`.

---

### Phase 2 — Writing Plan (HOW)
Convert specification into deterministic execution steps.

**Output → `plan.md`**
Must include:
- File-level changes
- Data flow
- Algorithms (if needed)
- Failure modes
- Test strategy

**Rules:**
- No implementation.
- Every step must map to spec.
- Stop and wait for explicit **GO**.

---

### Phase 3 — Executing Plan (DO)
Implement strictly according to plan.

**Rules:**
- No deviation without returning to Phase 1.
- Validate after each logical step.
- Prefer smallest correct change.

---

## Invariants

- Determinism > speed  
- Correctness > completeness  
- Explicitness > convenience  
- Reproducibility > intuition  

---

## Communication

- No filler.
- No praise.
- No summaries.
- State uncertainty explicitly.
- Slovenian (discussion), English (code/tech).

---

## Environment

- Shell: `zsh`
- Node: `nvm` (lazy loaded)
- Python: `python` (lazy loaded)

**Implication:**
- First invocation of `node`, `npm`, `python`, or `pip` may have startup delay.

---

## Code Rules

### General
- Read existing code first.
- Match conventions exactly.
- No hidden side effects.

### Dependencies
- Forbidden without approval.

### Changes
- >50 LOC → require plan.

### Testing
- Failing tests → immediate stop.
- No fix-forward.

### Comments
- Explain **why**, not **what**.

---

## Tech Defaults

### TypeScript
- `strict: true`
- No `any`
- Named exports
- Zod validation

### Python
- Type hints mandatory
- `ruff`
- `pytest`

### Bash
- `set -euo pipefail`
- shellcheck clean

---

## Git Protocol

### Allowed
- `status`, `diff`, `log`, `show`

### Restricted
- `add`, `commit` → require approval  
- `push`, branching → forbidden without explicit command  

### Commit Flow
1. Propose commit
2. Provide conventional message
3. Wait for approval
4. Execute

---

## Security

- No secrets in code
- Use `.env`
- Scan diffs before commit

---

## Failure Handling

On any inconsistency:
1. Stop
2. Identify root cause
3. Return to Phase 1

---

## Trigger Keywords

- `superpowers brainstorming` → Phase 1  
- `writing-plan` → Phase 2  
- `GO` → Phase 3  
- `fix` → reproduce → isolate → fix  
- `refactor` → preserve behavior  

---

## Anti-Patterns (FORBIDDEN)

- Writing code during Phase 1 or 2  
- Implicit assumptions  
- Silent deviations from plan  
- Adding dependencies without approval  
- Continuing after test failure  
