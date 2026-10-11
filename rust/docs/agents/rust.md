# Rust Conventions

Read this when creating or changing Rust code. Follow the project's edition, toolchain, feature policy, and existing patterns. rustfmt and Clippy are the mechanical style sources of truth.

## Core rules

- Write readable Rust with clear ownership boundaries, cohesive types, and small focused functions.
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
- Async, concurrency, cancellation, and blocking → `docs/agents/rust/async.md`

## Completion

Follow existing CI. Common checks are `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings`, and `cargo test --workspace`, with the project's supported targets and features.
