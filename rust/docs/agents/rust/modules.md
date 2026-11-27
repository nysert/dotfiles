# Modules and Public APIs

Read when adding or changing crates, modules, traits, feature flags, or exported types.

- Preserve workspace and module naming conventions.
- Put application workflows in [service modules](../architecture/services.md). Reusable libraries may organize cohesive modules by domain or capability.
- Separate independent responsibilities across all production modules, including controllers, models, repositories, providers, and workers. Give unrelated additions their own home even when an existing file is already large.
- Keep parent modules focused on declarations, intentional re-exports, and genuinely shared contracts.
- Split complex modules at responsibility boundaries and preserve caller-facing interfaces during internal reorganization. Use names that describe the responsibility and avoid catch-all modules.
- Default items to private and expose only the contract needed by callers.
- Prefer functions and concrete types until polymorphism clearly benefits the design.
- Introduce traits at meaningful substitution/test boundaries, not to wrap every single implementation.
- Avoid deeply nested layers and opaque re-export trees without a clear benefit.
- Document public contracts and invariants; add doctests for useful executable examples.
- Respect Cargo feature policies and avoid accidentally enabling contradictory feature combinations.
- Treat published-crate compatibility as a real contract: do not break public APIs or serialized formats incidentally.

Apply [complexity review](complexity.md) whenever creating, modifying, reviewing, or decomposing handwritten production modules.
