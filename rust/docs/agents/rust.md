# Rust Conventions

Read this when creating or changing Rust code. Follow the project's edition, toolchain, feature policy, and existing patterns. rustfmt and Clippy are the mechanical style sources of truth.

## Core rules

- Write readable Rust with clear ownership boundaries, cohesive types, and small focused functions.
- Keep independent responsibilities in separate modules and review module and function complexity when adding or materially modifying handwritten production code.
- Prefer enums for closed states and newtypes when they prevent confusing unrelated identifiers.
- Borrow for short-lived access; use owned data when ownership simplifies a genuine lifetime boundary. Do not clone merely to placate the borrow checker.
- Use `Result` for recoverable failures and `Option` for legitimate absence; retain useful error context.
- Do not panic on routine or untrusted input. `unwrap`/`expect` are acceptable in tests or for clearly justified invariants.
- Prefer concrete types until traits/generics solve an actual problem; avoid speculative layers and clever macros.
- Respect existing crate boundaries, public APIs, and feature combinations.
- Document non-obvious invariants and avoid `unsafe` without a demonstrated need.

## Read when relevant

- Ownership, borrowing, failures, and panics → `docs/agents/rust/ownership-errors.md`
- Modules, crates, traits, and public APIs → `docs/agents/rust/modules.md`
- File length, function complexity, module decomposition, and complexity enforcement → `docs/agents/rust/complexity.md` (required for handwritten production module changes and reviews)
- Async, concurrency, cancellation, and blocking → `docs/agents/rust/async.md`

## Completion

Follow existing CI and use the project's supported targets and feature combinations. Common checks are `cargo fmt --all -- --check`, `cargo test --workspace`, and Clippy with the complexity lints enabled. Reuse existing workspace lint levels when they already enable these lints. Otherwise, run:

```sh
cargo clippy --workspace --all-targets -- \
  -D warnings \
  -W clippy::too_many_lines \
  -W clippy::cognitive_complexity \
  -W clippy::too_many_arguments
```

The Clippy configuration supplies thresholds. Enable the individual lints through workspace configuration or the command above. See [complexity review](rust/complexity.md) for manual checks and narrowly scoped exceptions.
