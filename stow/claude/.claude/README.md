# `.claude/` — Global Configuration for Claude Code

This folder configures how Claude Code works across **all** projects and encodes
personal engineering standards so that generated and reviewed code is clean, consistent,
and professional by default.

It lives at `stow/claude/.claude/` in this dotfiles repo and is symlinked by GNU Stow
into `~/.claude/`, where Claude Code loads it automatically for every session,
regardless of which project you're working in.

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

1. From the dotfiles repo root, run `stow claude` (or your usual `install.sh`/`make`
   target) to symlink this folder to `~/.claude/`.
2. `CLAUDE.md`'s **Project-specific context** section is left as generic placeholders
   on purpose — it's global, so per-project specifics belong in that project's own
   `CLAUDE.md` instead.
3. Adjust `settings.json` permissions to match how much autonomy you want to grant.
4. Tweak the standards in `docs/` to fit how you work — they're a strong default, not dogma.
5. In Claude Code, try `/review` on a branch with changes, or ask Claude to use the
   `code-reviewer` agent.

## Customizing

These standards are intentionally opinionated but general. Treat them as a starting
point: sharpen the language-specific rules, add ADRs under `docs/adr/`, and add your
own slash commands and agents as your workflow grows. Since this config is global,
changes here apply to every project immediately after Stow re-links (or on next
session if already linked).
