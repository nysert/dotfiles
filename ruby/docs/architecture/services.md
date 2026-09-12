# Services

Detailed guidance referenced by `docs/architecture.md`. Read this file only when this topic is relevant to the task.

## Services

Put meaningful application and business workflows in:

```text
app/services/
```

Use plural domain namespaces and action-oriented class names.

Prefer:

Long example moved to `docs/architecture/examples.md` → **Services — example 1**.

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

Long example moved to `docs/architecture/examples.md` → **Service naming — example 2**.

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

Long example moved to `docs/architecture/examples.md` → **Service design — example 3**.

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
