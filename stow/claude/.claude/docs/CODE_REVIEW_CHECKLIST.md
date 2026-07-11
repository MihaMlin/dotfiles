# Code Review Checklist

Use this as a rubric when reviewing (or self-reviewing) a change before it merges.
A "no" on anything below is a blocker or a conversation, not a rubber stamp.

## Correctness
- [ ] Does the code do what the PR says it does?
- [ ] Are edge cases handled: empty input, nulls, boundaries, large input, concurrency?
- [ ] Are error and failure paths handled, not just the happy path?
- [ ] Would this break any existing behavior or contract?

## Clarity & style
- [ ] Can I understand each function without reading it twice?
- [ ] Do names reveal intent? (See NAMING_CONVENTIONS.md)
- [ ] Are functions small and single-purpose? (See STYLE_GUIDE.md §2)
- [ ] Is there dead code, commented-out code, or leftover debug logging to remove?
- [ ] Do comments explain *why*, and are they still accurate?
- [ ] Is the formatter satisfied? (No manual formatting debates.)

## Architecture
- [ ] Is this logic in the right layer? (Domain stays free of I/O and frameworks.)
- [ ] Does it introduce a circular dependency or leak an internal detail?
- [ ] Is duplication real (extract) or coincidental (leave it)?
- [ ] Is the public API of the touched module still small and intentional?

## Testing
- [ ] Are there tests, and would they fail without this change?
- [ ] Do tests cover the edges and the error paths, not just the happy path?
- [ ] Do test names describe behavior?
- [ ] Are tests deterministic (no reliance on real time, network, or ordering)?

## Security & safety
- [ ] No secrets, tokens, or credentials in the diff?
- [ ] Is external input validated and are queries parameterized?
- [ ] Is sensitive data kept out of logs?
- [ ] Least privilege for any new permission, scope, or access?

## Operability
- [ ] Are failures observable (useful logs/metrics with context)?
- [ ] Are resources (files, connections, locks) always released?
- [ ] Is anything performance-sensitive obviously O(n²) or worse on a hot path?

## Documentation
- [ ] Are public APIs documented?
- [ ] Is the README / relevant doc updated if behavior or setup changed?
- [ ] For a consequential design choice, is there an ADR?
