# Git & GitHub Standards

Rules for commit messages, PR descriptions, and attribution when Claude makes
changes in this repository.

---

## 1. Commit messages

- **Explain *why*, not just *what*.** The diff already shows what changed; the
  message should carry the reasoning, trade-off, or motivating context a diff
  can't express.
- **Imperative mood, short summary line.** `fix: handle empty response body`,
  not `fixed` or `fixes`.
- **One logical change per commit.** Don't bundle unrelated fixes or refactors.
- **Never amend or force-push published commits** unless explicitly asked.

## 2. Attribution

- **Never add a `Co-Authored-By: Claude` (or any Anthropic/Claude attribution)
  trailer to commit messages.**
- **Never reference a Claude Code session URL, session ID, or other
  Claude-authorship marker in a commit message, PR description, or PR comment.**
- Commits and PRs should read as if authored solely by the human developer.

## 3. Pull requests

- Keep the PR title short; put detail in the description.
- PR description covers: summary of the change (why, not just what) and a test
  plan.
- Do not push directly to `main`/`master` unless explicitly instructed.
- Never force-push a shared branch without explicit confirmation.

## 4. Safety

- Treat destructive git operations (`reset --hard`, `push --force`, `clean -f`,
  branch deletion) as requiring explicit confirmation before running.
- Run `git status` before any command that could discard uncommitted work.
