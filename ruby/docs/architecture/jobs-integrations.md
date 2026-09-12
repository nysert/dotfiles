# Jobs Integrations

Detailed guidance referenced by `docs/architecture.md`. Read this file only when this topic is relevant to the task.

## Rails conventions

Prefer standard Rails functionality before custom abstractions.

Prefer:

- RESTful routes.
- Conventional Rails controllers.
- Active Record associations.
- Active Record validations.
- Active Record scopes.
- Rails callbacks only for truly lifecycle-dependent behavior.
- Active Job for background work.
- Existing project abstractions over new abstractions.

Avoid raw SQL unless Active Record would make the implementation materially worse.

Do not add gems unless they provide meaningful value and Rails or existing dependencies cannot reasonably provide the functionality.

---
## Background jobs

Use background jobs for work that does not need to complete during the request cycle, including appropriate:

- Emails.
- Notifications.
- External API calls.
- Long-running processing.
- Scheduled work.

Keep business logic in services when possible and let jobs call those services.

Prefer:

```ruby
class Appointments::SendReminderJob < ApplicationJob
  def perform(appointment)
    Appointments::SendReminder.new(appointment:).call
  end
end
```

instead of placing the full workflow in the job.

Jobs should primarily:

- Deserialize inputs.
- Call the relevant service.
- Handle job-specific retry or queue behavior where appropriate.

---
## Data integrity

Use database constraints when they protect important invariants.

Use transactions when multiple writes form one atomic operation.

Prefer application validations for user feedback and database constraints for integrity when both are appropriate.

Be cautious with callbacks that create hidden multi-step behavior.

---
## External integrations

Keep external API orchestration outside controllers and models.

Prefer explicit service boundaries.

Do not spread provider-specific logic throughout the application.

Where practical, isolate:

- API client concerns.
- Authentication.
- Request/response normalization.
- Retry behavior.
- Application workflow.

Do not over-engineer an adapter layer unless multiple providers or meaningful complexity justify it.

---
## Architectural review

Before completing architecture-related work, verify:

- [ ] Controllers remain thin.
- [ ] Models contain intrinsic domain behavior, not application orchestration.
- [ ] Non-trivial workflows live in services.
- [ ] Service namespace and path match.
- [ ] Services expose a clear primary public API.
- [ ] Transactions protect atomic operations.
- [ ] Background jobs delegate business logic where practical.
- [ ] Existing project abstractions were reused.
- [ ] No speculative architectural family was introduced.
