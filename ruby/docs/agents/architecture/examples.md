# Architecture Examples

Concrete examples moved out of the topical `architecture` guidance files to keep rule context small. Read this file only when a concrete implementation example is useful.

## Controllers — example 1

Source topic: `controllers-models.md`

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

## Services — example 1

Source topic: `services.md`

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

## Service naming — example 2

Source topic: `services.md`

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

## Service design — example 3

Source topic: `services.md`

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
