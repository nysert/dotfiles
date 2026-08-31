# Application Architecture

Use this file when modifying controllers, models, services, background jobs, or application/business logic.

The application should favor conventional Rails structure with explicit service objects for non-trivial workflows.

---

## Core principles

Prefer:

- Thin controllers.
- Thin models.
- Business workflows in `app/services`.
- Background jobs for asynchronous work.
- Standard Rails functionality before custom abstractions.
- Existing project patterns before new patterns.

Avoid speculative architecture.

Do not introduce new architectural families such as:

```text
app/interactors/
app/operations/
app/commands/
app/use_cases/
```

unless the project already intentionally uses them for a distinct purpose.

---

## Controllers

Controllers should primarily:

- Authenticate.
- Authorize.
- Read and validate request parameters.
- Call application services.
- Render or redirect based on the result.

Do not put substantial business logic, external API orchestration, or multi-step workflows directly in controllers.

Prefer:

```ruby
class UsersController < ApplicationController
  def create
    result = Users::Create.new(user_params).call

    if result.success?
      redirect_to result.user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:name, :email])
  end
end
```

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

## Services

Put meaningful application and business workflows in:

```text
app/services/
```

Use plural domain namespaces and action-oriented class names.

Prefer:

```text
app/services/users/create.rb
app/services/users/delete.rb
app/services/users/login.rb

app/services/appointments/create.rb
app/services/appointments/cancel.rb
app/services/appointments/reschedule.rb

app/services/payments/charge.rb
app/services/payments/refund.rb
```

The class must match the path.

Example:

```text
app/services/users/create.rb
```

contains:

```ruby
class Users::Create
  def initialize(...)
    ...
  end

  def call
    ...
  end
end
```

---

## Service naming

Use plural domain namespaces.

Prefer:

```ruby
Users::Create
Users::Delete
Users::Login

Appointments::Create
Appointments::Cancel
Appointments::Reschedule

Payments::Charge
Payments::Refund

Subscriptions::Create
Subscriptions::Renew
Subscriptions::Cancel
```

Use action-oriented class names.

Prefer:

```ruby
Users::Register
Payments::Charge
Appointments::Reschedule
Subscriptions::Renew
```

Avoid generic implementation-oriented names such as:

```ruby
UserService
PaymentProcessor
AppointmentManager
SubscriptionHandler
```

Do not add a redundant `Service` suffix.

Avoid:

```ruby
Users::CreateService
Appointments::CancelService
```

Do not add a top-level `Services` namespace.

Avoid:

```ruby
Services::Users::Create
Services::Appointments::Cancel
```

The convention is:

- `app/services` identifies the object as a service.
- The namespace identifies the domain.
- The class identifies the action.

---

## Service design

Prefer one primary public entry point:

```ruby
#call
```

Example:

```ruby
class Appointments::Cancel
  def initialize(appointment:)
    @appointment = appointment
  end

  def call
    ActiveRecord::Base.transaction do
      appointment.update!(status: :cancelled)
      appointment.reminders.destroy_all
    end

    appointment
  end

  private

  attr_reader :appointment
end
```

Use private helper methods when they improve readability.

Prefer explicit dependencies when interacting with external systems.

Use database transactions when an operation must succeed or fail atomically.

A service is especially appropriate when an operation involves:

- Multiple models.
- Multiple database writes.
- External APIs.
- Notifications.
- Emails.
- SMS or messaging.
- Background jobs.
- Transactions.
- Several business rules.
- Multi-step workflows.

Do not create services merely to wrap trivial Active Record operations.

For example, this generally does not require a service:

```ruby
User.find(params[:id])
```

Before creating a new service, search for an existing service or application pattern that already solves the problem.

---

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
