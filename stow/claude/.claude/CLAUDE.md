# Project Standards

> This file is loaded automatically at the start of every Claude Code session.
> It is the single source of truth for how code in this project should be written,
> structured, and reviewed. Keep it short — details live in the linked documents.

## How to use these standards

When writing or reviewing code in this repository, follow the standards in the
linked documents below. If a request conflicts with these standards, flag the
conflict and propose a compliant alternative rather than silently deviating.

- **Code & formatting standards** — see @docs/STYLE_GUIDE.md
- **Naming conventions** — see @docs/NAMING_CONVENTIONS.md
- **Architecture principles** — see @docs/ARCHITECTURE.md
- **Review checklist** — see @docs/CODE_REVIEW_CHECKLIST.md

## Non-negotiables (the short list)

1. **Clarity over cleverness.** Optimize for the next person reading the code.
2. **Small, single-purpose units.** Functions do one thing; modules own one concern.
3. **Names carry intent.** No abbreviations, no `data`/`tmp`/`obj` placeholders.
4. **No dead code, no commented-out blocks.** Delete it; version control remembers.
5. **Fail loudly, fail early.** Validate inputs at boundaries; never swallow errors.
6. **Every change is tested.** New behavior ships with tests that would fail without it.
7. **Formatting is automated, not debated.** The formatter is the authority.
8. **No secrets in code.** Credentials come from environment/config, never literals.

## Working agreements for Claude

- Prefer editing existing files over creating new ones unless a new module is warranted.
- Before large refactors, propose a short plan and wait for confirmation.
- When unsure about a convention, ask or check the linked docs — do not guess.
- Match the surrounding code's existing style when it doesn't violate these standards.
- Explain *why* in commit messages and PR descriptions, not just *what*.

## Project-specific context

<!-- Fill these in for your project so Claude has the right context. -->

- **Primary language(s):** _e.g. TypeScript, Python_
- **Framework(s):** _e.g. React, FastAPI_
- **Package manager:** _e.g. pnpm, uv_
- **Test command:** _e.g. `pnpm test`, `pytest`_
- **Lint/format command:** _e.g. `pnpm lint`, `ruff format`_
- **Build command:** _e.g. `pnpm build`_
