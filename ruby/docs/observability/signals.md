# Signals

Detailed guidance referenced by `docs/observability.md`. Read this file only when this topic is relevant to the task.

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
