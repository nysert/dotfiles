# Ruby Conventions

Use this file when creating or modifying Ruby code.

`.rubocop.yml` is the source of truth for mechanically enforceable Ruby formatting and style.

Do not duplicate or override RuboCop rules here unless the convention cannot be expressed reliably through RuboCop.

---

## General style

Prefer:

- Explicit, readable Ruby.
- Small methods.
- Clear naming.
- Simple control flow.
- Existing project idioms.
- Minimal metaprogramming unless it materially improves the design.

Avoid clever code when straightforward Ruby communicates the intent more clearly.

---

## Namespaces

Prefer compact namespace declarations when parent namespaces already exist.

Use:

```ruby
class A::B::C
  def call
  end
end
```

Do not prefer:

```ruby
module A
  module B
    class C
      def call
      end
    end
  end
end
```

Likewise, prefer:

```ruby
module A::B
end
```

over nested module declarations when the parent namespaces already exist.

---

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

## Completion

For Ruby changes, run the relevant tests while working.

Before completion, normally run:

```sh
bin/rubocop
bin/rails test
```

Do not fix unrelated existing failures unless required for the task.
