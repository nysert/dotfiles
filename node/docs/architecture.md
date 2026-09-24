# Application Architecture

Use this file when modifying HTTP handlers/controllers, services, background jobs, or application/business logic.

The application favors thin transport/framework layers and explicit modules for non-trivial workflows.

## Core rules

- Keep HTTP handlers, controllers, and resolvers thin.
- Parse and validate transport input at the boundary.
- Keep business/application workflows outside route handlers.
- Put meaningful multi-step workflows in the project's existing service/application layer.
- Prefer domain-oriented names and action-oriented operations.
- Avoid generic `Manager`, `Processor`, or `Helper` abstractions when a domain/action name communicates intent better.
- Keep database and external-provider details behind clear boundaries when doing so reduces coupling.
- Keep business logic out of background-job wrappers.
- Jobs should delegate to application behavior.
- Use database transactions for atomic workflows.
- Prefer standard framework functionality and existing project patterns before introducing new architectural layers.
- Do not introduce speculative architectural families such as commands, use-cases, interactors, or repositories unless the codebase intentionally uses them or the task clearly requires them.

## Read when relevant

- Service/workflow module naming and design → `docs/architecture/services.md`
