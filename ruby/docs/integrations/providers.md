# Providers

Detailed guidance referenced by `docs/integrations.md`. Read this file only when this topic is relevant to the task.

## Structure under app/services

Example:

```text
app/services/
└── messaging/
    ├── send_message.rb
    ├── gateway.rb
    └── providers/
        ├── twilio.rb
        └── meta.rb
```

For payments:

```text
app/services/payments/
├── charge.rb
├── refund.rb
├── gateway.rb
└── providers/
    ├── stripe.rb
    └── adyen.rb
```

Subdirectories under `app/services` are encouraged when they express a real domain boundary.
## Provider-independent workflows

Prefer application concepts such as:

```ruby
Payments::Charge.new(...).call
Messaging::SendMessage.new(...).call
Ai::Generate.new(...).call
```

rather than provider-branded workflows outside the provider layer.

The rest of the application should not need to know which provider is active.
## Stable provider interface

When similar services may be swapped, define a small internal contract.

Example:

Long example moved to `docs/integrations/examples.md` → **Stable provider interface — example 1**.

Provider implementations should satisfy the same application-facing behavior.

Do not force every one-off integration into an abstraction when provider interchangeability has no practical value.
## Provider selection

Centralize provider selection using Rails credentials, runtime configuration, or a persisted tenant/account setting when provider choice is tenant-specific.

Do not scatter `if provider == ...` branches across controllers, models, and jobs.
## Credentials

Store provider secrets in Rails credentials using the project's existing strategy.

Do not hard-code credentials in provider classes or expose server-side secrets to browser code.
## Normalize provider differences

Provider-specific request/response shapes should not leak into application workflows.

Normalize useful output into application-owned concepts such as:

```text
external_id
status
error_code
```

Persist raw provider responses only when genuinely useful and safe.
## Errors

Translate provider SDK errors into application-owned failures at the boundary.

Useful normalized categories include:

```text
timeout
rate_limited
authentication_failed
invalid_request
temporarily_unavailable
provider_error
```

The rest of the application should not need to rescue arbitrary SDK-specific exception classes.
