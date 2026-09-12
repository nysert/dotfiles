# Implementation

Detailed guidance referenced by `docs/ruby.md`. Read this file only when this topic is relevant to the task.

## Formatting

Let RuboCop decide mechanically enforceable formatting.

Typical project expectations include:

- 2-space indentation.
- No tabs.
- Trailing commas in multiline arrays and hashes.
- Expanded multiline method bodies rather than one-line empty methods.

Do not hand-format code in ways that intentionally conflict with `.rubocop.yml`.

---
## Implementation guidance

Before creating a new Ruby abstraction:

1. Search for an existing equivalent.
2. Prefer standard Rails or Ruby patterns.
3. Keep the public API small.
4. Avoid unnecessary inheritance.
5. Prefer composition when responsibilities are distinct.
6. Avoid speculative abstractions.

If behavior is application workflow or orchestration rather than intrinsic model behavior, follow `docs/architecture.md`.

---
