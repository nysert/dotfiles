# Security Testing

Detailed guidance referenced by `docs/observability.md`. Read this file only when this topic is relevant to the task.

## Sensitive data

Never include secrets in logs, error reports, metrics labels, traces, breadcrumbs, or observability context.

Be cautious with authentication headers, tokens, payment data, personal data, and full external request/response payloads.

Follow `docs/security.md`.
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
