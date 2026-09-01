# Integration Guidelines

Use this file when the application communicates with third-party APIs or external providers such as payments, email, SMS, WhatsApp, AI/LLM providers, storage, search, maps, or other external services.

All application-side integration code belongs under `app/services/`.

Do not create new top-level application directories such as:

```text
app/clients/
app/adapters/
app/gateways/
app/integrations/
```

## Core principle

Application workflows should depend on a stable internal interface, not directly on a provider SDK.

Provider-specific behavior should be isolated so providers can be switched with minimal application changes.

Prefer:

```text
Application workflow
        ↓
Internal service/provider interface
        ↓
Provider implementation
        ↓
Provider SDK/API
```

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

```ruby
class Messaging::Gateway
  def initialize(provider: default_provider)
    @provider = provider
  end

  def send_message(...)
    provider.send_message(...)
  end

  private

  attr_reader :provider
end
```

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

## Timeouts and retries

Every network integration must have explicit, reasonable timeouts.

Retry only transient failures such as temporary network errors, provider 5xx responses, or safe rate-limit responses.

Do not blindly retry validation or authentication failures.

Use bounded retries and backoff.

## Idempotency

Use idempotency when retrying could create duplicate side effects, especially for payments, resource creation, message dispatch, and webhook-triggered operations.

Use provider-supported idempotency keys where available and application-level protection where necessary.

## Webhooks

Webhook endpoints must:

1. Verify provider signatures when supported.
2. Parse events safely.
3. Deduplicate using stable provider event IDs when possible.
4. Acknowledge quickly.
5. Move substantial processing into jobs/services.

Do not trust a webhook merely because it reaches a secret-looking URL.

## Background jobs

External work that need not finish during the request cycle should use Active Job/Solid Queue.

Jobs should call services. Provider SDK orchestration remains in the provider layer.

## Testing

Ordinary tests must not depend on live third-party APIs.

Prefer dependency injection, HTTP stubs, provider fakes, and shared/contract tests when multiple providers implement the same interface.

When providers are interchangeable, test that each satisfies the same application-facing contract.

## Switching providers

A provider switch should ideally require changes only to configuration, credentials, and provider-specific implementation.

It should not require rewriting controllers, models, jobs, API endpoints, or domain workflows.

If provider changes require broad application edits, provider details have leaked past the integration boundary.

## Completion checklist

- [ ] Integration code lives under `app/services`.
- [ ] No new top-level client/adapter/integration directory under `app` was introduced.
- [ ] Application workflows do not depend directly on provider SDKs when a provider boundary is appropriate.
- [ ] Interchangeable providers share a stable internal contract.
- [ ] Provider selection is centralized.
- [ ] Secrets use Rails credentials.
- [ ] Provider responses/errors are normalized where useful.
- [ ] Network timeouts are explicit.
- [ ] Retries are bounded and limited to transient failures.
- [ ] Side-effecting retries are idempotent.
- [ ] Webhook signatures and duplicates are handled.
- [ ] Tests avoid live provider dependencies.
- [ ] Switching providers does not require broad application changes.
