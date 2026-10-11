# Application Architecture

Read for HTTP/CLI handlers, services, jobs, workflows, or application boundaries.

- Keep transport entry points thin: validate input, call application code, translate output and errors.
- Keep business rules separate from storage, provider, or transport details where it improves clarity and testing.
- Use domain-oriented names and explicit structs/enums; avoid generic `Manager` or `Helper` scaffolding.
- Prefer existing crate/module organization to a new architectural framework.
- Use database transactions for atomic persistence; define external side effects separately.
- Delegate background job entry points to reusable workflow logic.
- Introduce traits only at genuine boundaries where interchangeable implementations help.
- Choose sync or async based on actual I/O and concurrency requirements, not fashion.

## Read when relevant

- Services, dependencies, workflows, and side-effect ordering → `docs/agents/architecture/workflows.md`
