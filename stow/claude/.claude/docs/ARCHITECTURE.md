# Architecture Principles

How code is organized at the module, layer, and system level. Good architecture
keeps change cheap: a well-placed boundary means a new requirement touches one
place, not twenty.

---

## 1. Separation of concerns

Organize the system into layers with a strict, one-directional dependency rule.
A common, pragmatic layering:

```
┌─────────────────────────────────────────────┐
│  Interface / Delivery                       │  HTTP handlers, CLI, UI
│  (translates the outside world in and out)  │
├─────────────────────────────────────────────┤
│  Application / Use Cases                    │  orchestration, workflows
│  (coordinates the domain to do a task)      │
├─────────────────────────────────────────────┤
│  Domain / Core                              │  business rules, entities
│  (pure logic, no framework, no I/O)         │
├─────────────────────────────────────────────┤
│  Infrastructure                             │  DB, network, filesystem, APIs
│  (implements interfaces the core defines)   │
└─────────────────────────────────────────────┘
```

**The dependency rule:** source-code dependencies point *inward*. The domain knows
nothing about the database, the web framework, or the outside world. Infrastructure
depends on the domain, never the reverse. This keeps business logic testable and
lets you swap a database or framework without rewriting your core.

---

## 2. SOLID, briefly

- **S — Single Responsibility.** A module has one reason to change. If a class handles
  both persistence and formatting, split it.
- **O — Open/Closed.** Open for extension, closed for modification. Add behavior by
  adding code (a new implementation), not by editing a growing `switch`.
- **L — Liskov Substitution.** Any implementation of an interface must be usable
  wherever that interface is expected, without surprising the caller.
- **I — Interface Segregation.** Many small, focused interfaces beat one fat interface.
  A client shouldn't depend on methods it never calls.
- **D — Dependency Inversion.** High-level policy depends on abstractions; low-level
  detail implements them. Inject dependencies; don't `new` them up deep in the core.

---

## 3. Dependency management

- **Inject dependencies** (constructor or parameter injection) rather than constructing
  collaborators internally. This makes them substitutable and testable.
- **Depend on interfaces at boundaries.** The domain defines a `PaymentGateway`
  interface; the infrastructure layer provides the Stripe implementation.
- **No circular dependencies** between modules. A cycle means the boundary is in the
  wrong place — extract the shared abstraction into its own module.
- **Keep the dependency graph shallow and acyclic.** You should be able to draw it.

---

## 4. Module boundaries

- **High cohesion, low coupling.** Things that change together live together; things
  that don't are separated by a clear interface.
- **A module exposes a small, intentional public API** and hides its internals. Callers
  depend on the contract, not the implementation.
- **Organize by feature/domain, not by technical type.** Prefer:

  ```
  src/
    billing/        # everything about billing: model, service, repo, routes
    accounts/
    notifications/
  ```

  over `controllers/`, `services/`, `models/` split across unrelated features. Domain
  grouping keeps a change local.

---

## 5. Data flow and state

- **Push side effects to the edges.** Keep the core pure and deterministic; do I/O in
  a thin outer shell. This is easy to test and easy to reason about.
- **A single source of truth** for each piece of state. Derive, don't duplicate.
- **Make illegal states unrepresentable** where the type system allows it — model with
  enums, unions, and value objects so bad combinations can't be constructed.
- **Prefer explicit data over hidden global state.** Pass what a function needs;
  avoid reaching into globals or singletons.

---

## 6. Designing for change

- **YAGNI — You Aren't Gonna Need It.** Don't build abstraction for a future that may
  never arrive. Solve today's problem cleanly; refactor when the second use case appears.
- **DRY, but not prematurely.** Remove *real* duplication of knowledge. Two lines that
  look alike but change for different reasons are not duplication — don't couple them.
- **Rule of three.** Extract a shared abstraction on the third occurrence, not the first.
  Early abstractions calcify around the wrong shape.
- **Composition over inheritance.** Prefer assembling behavior from small pieces over
  deep inheritance hierarchies, which are rigid and hard to change.

---

## 7. Documentation of decisions

For consequential architectural choices, record an **Architecture Decision Record (ADR):**
a short markdown file capturing the context, the decision, the alternatives considered,
and the consequences. It answers "why is it this way?" for the next engineer — including
future you.

```
docs/adr/
  0001-use-postgres-for-primary-store.md
  0002-split-billing-into-its-own-module.md
```

---

## 8. Smells that signal an architecture problem

- A single change forces edits across many unrelated files → boundaries are wrong.
- A class or module named `...Manager`, `...Util`, or `...Helper` that keeps growing.
- The domain layer imports the web framework or the database driver.
- Circular imports, or a dependency graph you can't hold in your head.
- "We can't test this without spinning up the whole system" → too much coupling to I/O.
