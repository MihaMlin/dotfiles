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
├── CLAUDE.md                        # Auto-loaded memory: non-negotiables + skill index
├── settings.json                    # Permissions, hooks, statusline, model
├── README.md                        # This file
├── skills/                          # Full standards, loaded on demand
│   ├── writing-clean-code/          # Functions, comments, errors, state, tests
│   ├── naming-things/               # Functions, variables, types, files
│   ├── structuring-architecture/    # Layering, SOLID, dependencies, change
│   ├── reviewing-code/              # Rubric for reviewing a change before merge
│   └── writing-commits-and-prs/     # Commit messages, PRs, git safety
├── hooks/
│   └── format-file.sh               # Formats each file Claude writes (PostToolUse)
├── commands/                        # Slash commands (invoke with /name)
│   ├── review.md                    # /review   — review changes against the standards
│   ├── refactor.md                  # /refactor — clean up code, behavior-preserving
│   ├── test.md                      # /test     — write/improve tests to standard
│   └── document.md                  # /document — add why-focused documentation
└── agents/                          # Specialized subagents
    ├── code-reviewer.md             # Rigorous, standards-based review
    └── refactoring-specialist.md    # Behavior-preserving structural improvement
```

## How it fits together

- **`CLAUDE.md`** is loaded automatically at the start of every session. It is kept
  deliberately short — the non-negotiables plus an index of which skill to load when.
- **`skills/`** holds the full standards. Claude loads a skill only when the work calls
  for it, so the detail costs nothing on sessions that don't need it.
- **`hooks/`** are scripts the harness runs on events. `format-file.sh` runs after every
  Write/Edit and formats the file with the formatter that project already uses —
  project-local binaries first, silent no-op when none is installed.
- **`commands/`** are shortcuts you trigger manually, e.g. type `/review` in Claude Code.
- **`agents/`** are specialists Claude can delegate to for focused review or refactoring.
- **`settings.json`** also blanks commit/PR attribution, so the standard in
  `writing-commits-and-prs` is enforced by the harness instead of by reminder.

## Getting started

1. From the dotfiles repo root, run `stow claude` (or your usual `install.sh`/`make`
   target) to symlink this folder to `~/.claude/`.
2. Per-project specifics (languages, test/lint/build commands) belong in that project's
   own `CLAUDE.md` — this config is global, so it stays language-agnostic.
3. Adjust `settings.json` permissions to match how much autonomy you want to grant.
4. Tweak the standards in `skills/` to fit how you work — they're a strong default, not
   dogma. Run `/hooks` once to review the formatting hook.
5. In Claude Code, try `/review` on a branch with changes, or ask Claude to use the
   `code-reviewer` agent.

## Customizing

These standards are intentionally opinionated but general. Treat them as a starting
point: sharpen the language-specific rules, add new skills as your workflow grows, and
add ADRs under a project's own `docs/adr/`. Since this config is global, changes here
apply to every project immediately after Stow re-links (or on next session if already
linked). New skills and hooks are picked up on the next session.
