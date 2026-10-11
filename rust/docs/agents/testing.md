# Testing Guidelines

Read for behavior changes and regression tests.

- Follow the project's test framework, fixtures, and feature/target policy.
- Test observable behavior and public contracts rather than implementation details.
- Exercise meaningful error handling, edge cases, and resource cleanup.
- Prefer deterministic unit tests for pure behavior and integration tests at important boundaries.
- Avoid sleeps and live external providers when controlled fixtures will do.
- Test concurrency, cancellation, ordering, or race-prone invariants when relevant.
- Run the narrowest useful test first, then the affected area and broader completion suite.
- Do not fix unrelated existing failures.

## Read when relevant

- Working strategy, commands, completion checklist → `docs/agents/testing/workflow.md`

Typical checks: `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings`, `cargo test --workspace`. Use CI's actual toolchain, features, and integration services.
