# Ruby Conventions

Use this file when creating or modifying Ruby code.

`.rubocop.yml` is the source of truth for mechanically enforceable Ruby formatting and style. Do not duplicate or override RuboCop rules here unless the convention cannot be expressed reliably through RuboCop.

## Core rules

- Prefer explicit, readable Ruby, small methods, clear naming, simple control flow, and existing project idioms.
- Avoid clever code and unnecessary metaprogramming.
- Prefer compact namespace declarations when parent namespaces already exist.
- Before creating a new abstraction, search for an existing equivalent and prefer standard Ruby/Rails patterns.
- Avoid speculative abstractions and unnecessary inheritance.
- For workflows/orchestration rather than intrinsic model behavior, follow `docs/architecture.md`.

## Read when relevant

- Namespace conventions and examples → `docs/ruby/namespaces.md`
- Formatting and abstraction guidance → `docs/ruby/implementation.md`

## Completion

For Ruby changes, run relevant tests while working. Before completion, normally run:

```sh
bin/rubocop
bin/rails test
```

Do not fix unrelated existing failures unless required for the task.
