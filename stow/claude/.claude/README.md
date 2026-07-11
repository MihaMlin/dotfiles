# `.claude/` — Project Configuration for Claude Code

This folder configures how Claude Code works within this repository and encodes the
team's engineering standards so that generated and reviewed code is clean, consistent,
and professional by default.

## What's here

```
.claude/
├── CLAUDE.md                     # Auto-loaded memory: the standards entry point
├── settings.json                 # Permissions and project settings
├── README.md                     # This file
├── docs/
│   ├── STYLE_GUIDE.md            # Clean-code standards: functions, formatting, errors
│   ├── NAMING_CONVENTIONS.md     # How to name functions, variables, types, files
│   ├── ARCHITECTURE.md           # Layering, SOLID, dependencies, designing for change
│   └── CODE_REVIEW_CHECKLIST.md  # Rubric for reviewing changes before merge
├── commands/                     # Slash commands (invoke with /name)
│   ├── review.md                 # /review  — review changes against the standards
│   ├── refactor.md               # /refactor — clean up code, behavior-preserving
│   ├── test.md                   # /test    — write/improve tests to standard
│   └── document.md               # /document — add why-focused documentation
└── agents/                       # Specialized subagents
    ├── code-reviewer.md          # Rigorous, standards-based review
    └── refactoring-specialist.md # Behavior-preserving structural improvement
```

## How it fits together

- **`CLAUDE.md`** is loaded automatically at the start of every session. It states the
  non-negotiable rules and links to the detailed docs, so Claude always writes code to
  your standard without being reminded.
- **`docs/`** holds the full standards. `CLAUDE.md` imports them via `@docs/...`
  references, and the commands and agents cite them, so there is one source of truth.
- **`commands/`** are shortcuts you trigger manually, e.g. type `/review` in Claude Code.
- **`agents/`** are specialists Claude can delegate to for focused review or refactoring.

## Getting started

1. Drop this `.claude/` folder into the root of your repository.
2. Open `CLAUDE.md` and fill in the **Project-specific context** section (language,
   test command, lint command, etc.).
3. Adjust `settings.json` permissions to match how much autonomy you want to grant.
4. Tweak the standards in `docs/` to fit your team — they're a strong default, not dogma.
5. In Claude Code, try `/review` on a branch with changes, or ask Claude to use the
   `code-reviewer` agent.

## Customizing

These standards are intentionally opinionated but general. Treat them as a starting
point: sharpen the language-specific rules, add ADRs under `docs/adr/`, and add your
own slash commands and agents as your workflow grows.
