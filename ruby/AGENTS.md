# AGENTS.md

## Project

This is a Ruby on Rails application.

Follow existing Rails conventions and project patterns unless this file explicitly defines a different convention.

Keep changes focused on the requested task.

Do not modify unrelated code unless required for correctness.

---

## Ruby style

`.rubocop.yml` is the source of truth for Ruby formatting and style.

Use:

- 2 spaces for indentation.
- No tabs.
- Trailing commas in multiline arrays and hashes.
- Expanded multiline methods instead of one-line empty methods.

Prefer compact namespace declarations.

Use:

```ruby
class A::B::C
  def call
  end
end
```

Do not use:

```ruby
module A
  module B
    class C
      def call
      end
    end
  end
end
```

Likewise, prefer:

```ruby
module A::B
end
```

over nested module declarations when the parent namespaces already exist.

---

## Application architecture

Prefer thin controllers and thin models.

Most application workflows, orchestration, and business logic should live in `app/services`.

### Controllers

Controllers should primarily:

- Authenticate.
- Authorize.
- Read and validate request parameters.
- Call application services.
- Render or redirect based on the result.

Do not put substantial business logic, workflows, external API orchestration, or multi-step operations directly in controllers.

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

over implementing the complete user-creation workflow inside the controller.

### Models

Models should primarily contain:

- Associations.
- Validations.
- Scopes.
- Persistence-related behavior.
- Small pieces of behavior intrinsic to the model.

Avoid filling Active Record models with application workflows or orchestration.

Behavior that naturally describes the object itself may remain on the model.

For example:

```ruby
appointment.cancelled?
user.active?
subscription.expired?
```

A workflow involving several operations should generally be implemented as a service.

---

## Services

Put most application and business logic in:

```text
app/services/
```

Organize services by plural domain namespace and action.

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

The class should match the path.

For example:

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

And:

```text
app/services/appointments/reschedule.rb
```

contains:

```ruby
class Appointments::Reschedule
  def initialize(...)
    ...
  end

  def call
    ...
  end
end
```

### Service naming

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

- The `app/services` folder identifies the object as a service.
- The namespace identifies the domain.
- The class identifies the action.

### Service design

Prefer one public entry point:

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

Use private helper methods where they improve readability.

Prefer explicit dependencies when services interact with external systems.

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

Before creating a new abstraction, check whether an existing service or application pattern already solves the problem.

Do not introduce parallel architectural concepts such as:

```text
app/interactors/
app/operations/
app/commands/
app/use_cases/
```

unless the project already intentionally uses them for a separate purpose.

---

## Rails conventions

Prefer standard Rails functionality before introducing custom abstractions.

Prefer:

- RESTful routes.
- Conventional Rails controllers.
- Active Record associations.
- Active Record validations.
- Active Record scopes.
- Rails callbacks only for behavior that is truly lifecycle-dependent.
- Active Job for background work.
- Existing project abstractions over new abstractions.

Avoid raw SQL unless Active Record would make the implementation significantly worse.

Do not add gems unless they provide meaningful value and the functionality cannot reasonably be implemented with Rails or existing dependencies.

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

instead of putting the entire workflow in the job.

---

## Tests

Add or update tests for behavior changed by the task.

Follow the testing framework and patterns already used by the application.

Test behavior rather than private implementation details.

Services containing meaningful business logic should generally have corresponding tests.

Run the most relevant tests while working.

Before considering Ruby changes complete, run:

```sh
bin/rails test
bin/rubocop
```

If the application has relevant system tests, also run:

```sh
bin/rails test:system
```

Do not fix unrelated existing test or RuboCop failures unless required for the requested task.

---

## Security

Never commit:

- Secrets.
- Credentials.
- API keys.
- Tokens.
- Passwords.
- Production data.

Use the project's existing secret-management mechanism, such as:

- Rails credentials.
- Environment variables.
- Secret-management services.

Treat all user-controlled input as untrusted.

Use Rails protections and existing application patterns for:

- Authentication.
- Authorization.
- CSRF protection.
- Parameter filtering.
- HTML escaping.
- SQL injection prevention.
- File uploads.

Do not bypass security protections merely to simplify implementation.

---

## Dependencies

Before adding a new gem:

1. Check whether Rails already provides the functionality.
2. Check whether an existing dependency already provides it.
3. Prefer a small internal implementation when appropriate.
4. Add a new dependency only when it meaningfully reduces complexity or risk.

Do not upgrade unrelated dependencies as part of an unrelated task.

---

## Changes

Keep implementations as simple as reasonably possible.

Prefer:

- Existing patterns.
- Small focused classes.
- Explicit code.
- Clear naming.
- Simple control flow.

Avoid speculative abstractions.

Do not create infrastructure for hypothetical future requirements unless the current task requires it.

When modifying existing behavior, preserve public behavior unless the task explicitly requires changing it.
