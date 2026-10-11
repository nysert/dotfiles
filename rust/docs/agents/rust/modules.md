# Modules and Public APIs

Read when adding or changing crates, modules, traits, feature flags, or exported types.

- Preserve workspace and module naming conventions.
- Prefer module-first organization by domain or capability (for example `products/`, `matching/`, or `parser/`), not mandatory layer directories like `services/`.
- Start with a single module for small features; split into related submodules when size or responsibilities warrant it.
- Organize modules around cohesive capabilities, not catch-all `utils` buckets.
- Default items to private and expose only the contract needed by callers.
- Prefer functions and concrete types until polymorphism clearly benefits the design.
- Introduce traits at meaningful substitution/test boundaries, not to wrap every single implementation.
- Avoid deeply nested layers and opaque re-export trees without a clear benefit.
- Document public contracts and invariants; add doctests for useful executable examples.
- Respect Cargo feature policies and avoid accidentally enabling contradictory feature combinations.
- Treat published-crate compatibility as a real contract: do not break public APIs or serialized formats incidentally.
