# Application Architecture

Read for module organization, HTTP/CLI handlers, jobs, application workflows, or boundaries.

## Default: module-first

- **Organize new Rust code into cohesive modules by domain or capability**, such as `products/`, `matching/`, `parser/`, or `storage/`; avoid forcing every project into an architectural layer structure.
- Keep entry points (`main.rs`, HTTP handlers, CLI commands, workers, scheduled tasks) thin: validate boundary input, call reusable modules, and translate results or errors.
- Put non-trivial workflows in focused functions/modules within the domain they serve (e.g. `products/create.rs`). Prefer functions and explicit data types over unnecessary service structs and traits.
- Keep domain invariants and intrinsic behavior close to their owning types/modules. Separate infrastructure and external side effects when it improves clarity or testing.
- **Do not require a `services/` directory.** Add a separate service/repository layer only where it clarifies real boundaries or matches an established project convention.
- Use meaningful domain/capability names instead of generic `Manager` or `Helper` scaffolding.
- Preserve existing crate and module conventions; start with small modules and split them as behavior grows, not in anticipation.
- Use database transactions for atomic persistence; handle external side effects separately.
- Delegate background job entry points to shared domain workflows.
- Introduce traits at genuine abstraction boundaries where polymorphism or substitution is useful.
- Choose sync or async based on actual I/O and concurrency needs.

## Framework compatibility

Respect the framework's generated files and routing conventions while keeping domain logic in reusable modules. A Loco.rs project may retain `controllers/`, `models/`, `workers/`, and `tasks/`, and add domain modules alongside them—without introducing `services/`.

## Read when relevant

- Workflow composition, dependencies, retries, and side-effect ordering → `docs/agents/architecture/workflows.md`
- Loco.rs conventions and a module-first example → `docs/agents/architecture/loco.md`
