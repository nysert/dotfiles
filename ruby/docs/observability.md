# Observability Guidelines

Use this file when adding or modifying logging, error reporting, metrics, tracing, or observability providers.

All application-side observability abstractions and provider implementations belong under `app/services/`.

Do not create new top-level directories such as:

```text
app/observability/
app/telemetry/
app/clients/
app/instrumentation/
```

## Core principle

Application code should emit meaningful application-level observability information through a stable internal interface when provider portability matters.

Provider SDK details should remain isolated.

Prefer:

```text
Application code
      ↓
Observability service
      ↓
Provider implementation
      ↓
Sentry / Honeybadger / Datadog / etc.
```

## Structure under app/services

Example:

```text
app/services/observability/
├── errors.rb
├── events.rb
├── metrics.rb
└── providers/
    ├── sentry.rb
    ├── honeybadger.rb
    └── datadog.rb
```

Only add capabilities the application actually uses.

## Provider abstraction

Where provider portability is useful, expose a small internal contract.

Example:

```ruby
class Observability::Errors
  def initialize(provider: default_provider)
    @provider = provider
  end

  def capture(exception, context: {})
    provider.capture(exception, context:)
  end

  private

  attr_reader :provider
end
```

Application code should not need to know the configured vendor.

## Keep wrappers small

Do not reproduce an entire vendor SDK one-for-one behind a wrapper.

Expose application capabilities such as:

- Capture an exception.
- Record an operational/domain event.
- Record a metric.
- Add scoped context.
- Measure a duration.

The internal interface should remain smaller and more stable than the provider API.

## Rails logging

Continue using Rails logger for ordinary logs.

Do not route every log line through an observability abstraction.

Provider wrappers are most useful for error reporting, metrics, tracing, and important operational events.

## Structured context

Prefer structured metadata with stable field names such as:

```text
request_id
job_id
user_id
account_id
service
operation
provider
external_request_id
```

Do not encode all metadata into one long string when structured context is available.

## Sensitive data

Never include secrets in logs, error reports, metrics labels, traces, breadcrumbs, or observability context.

Be cautious with authentication headers, tokens, payment data, personal data, and full external request/response payloads.

Follow `docs/security.md`.

## Error reporting

Capture unexpected exceptions with enough context to debug them.

Do not manually report errors already captured by framework/provider integrations unless additional handling is needed; avoid duplicate reports.

When rescuing an exception that would otherwise disappear, explicit capture may be appropriate.

## Expected failures

Do not treat normal validation failures, routine authorization denials, expected 404s, or ordinary user-input errors as exceptional errors.

Use logs or metrics when operationally useful.

## Events

Use application/domain names such as:

```text
appointment.reminder_sent
payment.failed
webhook.rejected
integration.rate_limited
```

Do not name events after the observability vendor.

## Metrics

Metrics should answer operational questions such as counts, success/failure rates, duration, queue delay, provider error rates, retries, and critical workflow completion.

Avoid uncontrolled high-cardinality labels such as user IDs, emails, request IDs, or UUIDs.

## Tracing

Add traces where they help diagnose meaningful cross-system or multi-step work, such as external HTTP calls, important jobs, expensive DB operations, or cross-service requests.

Do not instrument every method.

## Provider selection

Centralize observability provider selection.

Use Rails credentials for provider secrets and runtime/project configuration for provider choice.

Switching provider should primarily require configuration, credentials, and provider implementation changes—not broad application edits.

## Failure behavior

Observability must not become a critical dependency for normal application correctness.

If telemetry submission fails, business workflows should normally continue.

Do not let a failed logging/metrics/error-report request turn a successful business operation into a failure.

## Testing

Tests must not require live observability services.

Use fakes/stubs and test important context mapping, filtering, normalization, and failure-safe behavior where custom logic exists.

Do not assert vendor SDK implementation details throughout unrelated tests.

## Completion checklist

- [ ] Observability code lives under `app/services`.
- [ ] No new top-level observability/client directory under `app` was introduced.
- [ ] Provider SDK usage is isolated where portability matters.
- [ ] Internal interfaces expose application concepts rather than vendor APIs.
- [ ] Rails logger remains the default for ordinary logs.
- [ ] Structured context uses stable fields.
- [ ] Secrets and sensitive payloads are not reported.
- [ ] Expected user failures are not treated as unexpected exceptions.
- [ ] Metrics avoid uncontrolled high cardinality.
- [ ] Observability failure does not normally break business workflows.
- [ ] Provider choice is centralized.
- [ ] Tests do not depend on live observability services.
