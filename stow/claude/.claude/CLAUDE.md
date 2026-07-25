# Project Standards

> Loaded automatically at the start of every session. It stays short on purpose: the
> full standards live in skills that load only when they are actually needed.

## Non-negotiables (the short list)

1. **Clarity over cleverness.** Optimize for the next person reading the code.
2. **Small, single-purpose units.** Functions do one thing; modules own one concern.
3. **Names carry intent.** No abbreviations, no `data`/`tmp`/`obj` placeholders.
4. **No dead code, no commented-out blocks.** Delete it; version control remembers.
5. **Fail loudly, fail early.** Validate inputs at boundaries; never swallow errors.
6. **Every change is tested.** New behavior ships with tests that would fail without it.
7. **Formatting is automated, not debated.** The formatter is the authority.
8. **No secrets in code.** Credentials come from environment/config, never literals.
9. **Commits and PRs read as authored solely by me.** No Claude/Anthropic attribution
   trailers, no session URLs. Never amend or force-push published commits unless asked.

## Where the detail lives

Invoke the matching skill instead of guessing — each holds the full standard:

| Skill | Use it when |
| --- | --- |
| `writing-clean-code` | writing or changing code: functions, errors, state, comments, tests |
| `naming-things` | naming anything, or fixing a vague name |
| `structuring-architecture` | module boundaries, layering, dependencies |
| `reviewing-code` | reviewing a change before merge |
| `writing-commits-and-prs` | commit messages, PR descriptions, risky git operations |

## Working agreements

- Prefer editing existing files over creating new ones unless a new module is warranted.
- Before large refactors, propose a short plan and wait for confirmation.
- When unsure about a convention, load the relevant skill or ask — do not guess.
- Match the surrounding code's existing style when it doesn't violate these standards.
- Explain *why* in commit messages and PR descriptions, not just *what*.
- If a request conflicts with these standards, flag the conflict and propose a
  compliant alternative rather than silently deviating.

Per-project specifics (languages, test/lint/build commands) belong in that project's
own `CLAUDE.md`, not here — this file is global.
