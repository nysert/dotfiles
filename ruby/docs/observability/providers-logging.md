# Providers Logging

Detailed guidance referenced by `docs/observability.md`. Read this file only when this topic is relevant to the task.

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

Long example moved to `docs/observability/examples.md` → **Provider abstraction — example 1**.

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
## Provider selection

Centralize observability provider selection.

Use Rails credentials for provider secrets and runtime/project configuration for provider choice.

Switching provider should primarily require configuration, credentials, and provider implementation changes—not broad application edits.
## Failure behavior

Observability must not become a critical dependency for normal application correctness.

If telemetry submission fails, business workflows should normally continue.

Do not let a failed logging/metrics/error-report request turn a successful business operation into a failure.
