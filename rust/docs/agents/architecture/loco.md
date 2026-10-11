# Loco.rs Module-First Architecture

Read only for Loco.rs applications.

Loco.rs provides conventional locations for generated HTTP controllers, SeaORM models/entities, workers, tasks, and app setup. **Keep those conventions**; they do not require that all business logic stay inside controllers or models.

## Recommended organization

For a Loco.rs project that needs non-trivial reusable workflows, add domain/capability modules alongside framework-owned directories:

```text
src/
├── app.rs
├── lib.rs
├── controllers/
│   └── products.rs      # HTTP boundary, routes
├── models/
│   ├── products.rs      # SeaORM/domain model conventions
│   └── _entities/       # Generated entities where used
├── products/
│   ├── mod.rs
│   ├── create.rs        # Reusable application workflow
│   └── pricing.rs       # Domain-specific logic
├── matching/
│   ├── mod.rs
│   └── score.rs
├── workers/             # Background entry points
└── tasks/               # CLI entry points
```

Only create directories and files needed for the actual project. The generated Loco layout and version take precedence over this illustrative tree.

## Boundaries

- Controllers handle HTTP input, authentication/authorization integration, routing, and response formatting. Delegate substantive workflow logic to domain modules such as `products::create`.
- Workers and CLI tasks can call the same reusable domain functions; do not duplicate business rules across entry points.
- SeaORM models/entities can own intrinsic data/domain behavior; keep multi-step orchestration outside framework adapters.
- Pass needed dependencies (for example database connections) explicitly where practical. Use Loco's existing `AppContext` at framework boundaries rather than introducing a redundant global state layer.
- A new `src/services/` or repository abstraction is **optional**, not a requirement of Rust or Loco.rs. Create one when a project already uses it or it provides a meaningful organizational boundary.
- Register new modules and routes using the conventions of the project's Loco.rs version; preserve generated `app.rs` and module declarations.
