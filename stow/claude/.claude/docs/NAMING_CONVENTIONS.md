# Naming Conventions

Good names are the cheapest documentation you will ever write. A name should let
a reader understand a thing's purpose without reading its implementation.

---

## 1. Universal rules

- **Reveal intent.** The name should answer *why it exists*, *what it does*, and
  *how it is used*. `elapsedTimeInDays` beats `d`.
- **No abbreviations or cryptic shorthand.** Write `message`, not `msg`; `request`,
  not `req` (unless the abbreviation is a universal domain standard like `id`, `url`, `db`).
- **No placeholder names.** `data`, `info`, `tmp`, `obj`, `val`, `thing`, `foo`,
  `handle2` are banned in committed code.
- **No type/scope encoding (Hungarian notation).** Not `strName`, `iCount`,
  `m_value`, `arrItems`. The type system and IDE already tell you the type.
- **Pronounceable and searchable.** You should be able to say the name out loud and
  grep for it. Avoid single letters except for trivial loop indices in tiny scopes.
- **One word per concept.** Pick `fetch`, `get`, or `retrieve` and use it consistently
  across the codebase — don't mix synonyms for the same operation.
- **Avoid noise words.** `ProductData` and `ProductInfo` say nothing that `Product`
  doesn't. Drop redundant suffixes.
- **Scope length to lifetime.** Short names for short-lived, tightly-scoped variables
  (`i` in a 3-line loop is fine); long, descriptive names for anything with reach.

---

## 2. Functions and methods

- **Verb or verb phrase.** A function *does* something: `calculateTotal`,
  `sendInvitation`, `parseConfig`.
- **Predicates read as yes/no questions.** Boolean-returning functions start with
  `is`, `has`, `can`, `should`: `isEligible`, `hasPermission`, `canRetry`.
- **Getters/queries** use `get`/`find`/`fetch` with a clear distinction:
  `get` implies cheap/local, `fetch` implies I/O, `find` implies it may not exist.
- **Commands** use imperative verbs: `save`, `delete`, `publish`.
- **Match the return.** `getUsers` returns a collection; `getUser` returns one.
  Don't make `getUser` return a list.
- **Avoid double negatives.** `isEnabled` is clearer than `isNotDisabled`.

---

## 3. Variables and constants

- **Nouns or noun phrases** for values: `activeUsers`, `retryCount`, `defaultTimeout`.
- **Booleans read as assertions:** `isActive`, `hasErrors`, `shouldRetry` — never
  ambiguous like `status` or `flag`.
- **Collections are plural:** `orders`, `userIds`. A single item is singular: `order`.
- **Constants** carry meaning, not magic. Replace literals with named constants:

  ```js
  // Avoid
  if (attempts > 3) { ... }

  // Prefer
  const MAX_RETRY_ATTEMPTS = 3;
  if (attempts > MAX_RETRY_ATTEMPTS) { ... }
  ```

- **Units in the name** when a value has a unit: `timeoutMs`, `fileSizeBytes`,
  `distanceKm`. This prevents an entire class of bugs.

---

## 4. Classes, types, and interfaces

- **Nouns or noun phrases:** `PaymentProcessor`, `UserRepository`, `HttpClient`.
- **No `Manager`/`Helper`/`Util` grab-bags.** These names signal a class with no clear
  responsibility. Name it for what it actually owns.
- **Interfaces name a capability or role**, not an implementation: `Serializable`,
  `Repository`, `Clock`. Avoid `I`-prefixes unless the language community mandates it.
- **Exceptions/errors end in `Error`/`Exception`:** `ValidationError`, `TimeoutError`.

---

## 5. Files and directories

- **Match the ecosystem convention:**
  - JavaScript/TypeScript: `kebab-case.ts` for files; `PascalCase.tsx` for React components.
  - Python: `snake_case.py` for modules; `PascalCase` for the classes inside.
  - Go: `lowercase` package files; one package per directory.
- **File name mirrors its primary export.** A file exporting `PaymentProcessor` is
  `payment-processor.ts` (or `payment_processor.py`).
- **Directories name a domain or layer**, not a type: prefer `billing/` over `classes/`.

---

## 6. Casing summary

| Element                    | Convention (JS/TS)  | Convention (Python)        |
| -------------------------- | ------------------- | -------------------------- |
| Variable / function        | `camelCase`         | `snake_case`               |
| Class / type / component   | `PascalCase`        | `PascalCase`               |
| Constant                   | `UPPER_SNAKE_CASE`  | `UPPER_SNAKE_CASE`         |
| File (module)              | `kebab-case`        | `snake_case`               |
| Private member             | `#field` / `_field` | `_field`                   |
| Enum member                | `PascalCase`        | `UPPER_SNAKE_CASE`         |

Follow the language's official convention first; the table is the default when the
language is silent.

---

## 7. Before/after

```python
# Before
def calc(l, r):
    d = []
    for x in l:
        if x > r:
            d.append(x)
    return d

# After
def filter_above_threshold(values, threshold):
    return [value for value in values if value > threshold]
```

The second version needs no comment: the name says what it does, the parameters say
what it takes, and the body has nothing left to explain.
