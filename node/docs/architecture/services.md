# Services and Workflows

Detailed guidance referenced by `docs/architecture.md`.

Read this file when implementing non-trivial application or business workflows.

## Location

Use the service or application directory already established by the repository.

If no convention exists, a simple domain-oriented structure is preferred, for example:

```text
src/services/users/create.ts
src/services/users/register.ts
src/services/appointments/reschedule.ts
src/services/payments/charge.ts
```

Prefer one obvious primary exported operation for a workflow module.

Use explicit dependencies when external systems or side effects make ownership and testing clearer.

A service/workflow module is especially appropriate when an operation involves:

- multiple models/entities
- multiple database writes
- external APIs
- notifications
- email
- messaging
- background jobs
- transactions
- several business rules
- multi-step orchestration

Do not create a service merely to wrap a trivial ORM operation.

Before creating a new service/workflow, search for an existing application pattern that already owns the behavior.
