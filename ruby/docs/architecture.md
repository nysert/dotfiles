# Application Architecture

Use this file when modifying controllers, models, services, background jobs, or application/business logic.

The application favors conventional Rails structure with explicit service objects for non-trivial workflows.

## Core rules

- Keep controllers thin.
- Keep models focused on intrinsic domain/persistence behavior.
- Put meaningful workflows in `app/services`.
- Use plural domain namespaces and action-oriented service names; do not add a redundant `Service` suffix.
- Prefer one primary service entry point: `#call`.
- Keep business logic in services and let background jobs delegate to them.
- Use database transactions for atomic workflows.
- Prefer standard Rails functionality and existing project patterns before new abstractions.
- Do not introduce speculative architectural families such as `app/interactors`, `app/operations`, `app/commands`, or `app/use_cases` unless already intentionally used.

## Read when relevant

- Controllers and models → `docs/architecture/controllers-models.md`
- Service paths, naming, design, and examples → `docs/architecture/services.md`
- Rails conventions, jobs, integrity, and external integration boundaries → `docs/architecture/jobs-integrations.md`
- Long concrete examples → `docs/architecture/examples.md`
