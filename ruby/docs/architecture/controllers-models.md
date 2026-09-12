# Controllers Models

Detailed guidance referenced by `docs/architecture.md`. Read this file only when this topic is relevant to the task.

## Controllers

Controllers should primarily:

- Authenticate.
- Authorize.
- Read and validate request parameters.
- Call application services.
- Render or redirect based on the result.

Do not put substantial business logic, external API orchestration, or multi-step workflows directly in controllers.

Prefer:

Long example moved to `docs/architecture/examples.md` → **Controllers — example 1**.

over implementing the full creation workflow inside the controller.

---
## Models

Models should primarily contain:

- Associations.
- Validations.
- Scopes.
- Persistence-related behavior.
- Small pieces of behavior intrinsic to the model.

Behavior that naturally describes the object itself may remain on the model.

Examples:

```ruby
appointment.cancelled?
user.active?
subscription.expired?
```

Avoid filling Active Record models with application workflows, orchestration, or integration logic.

A workflow involving several operations should generally live in a service.

---
