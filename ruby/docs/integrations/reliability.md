# Reliability

Detailed guidance referenced by `docs/integrations.md`. Read this file only when this topic is relevant to the task.

## Timeouts and retries

Every network integration must have explicit, reasonable timeouts.

Retry only transient failures such as temporary network errors, provider 5xx responses, or safe rate-limit responses.

Do not blindly retry validation or authentication failures.

Use bounded retries and backoff.
## Idempotency

Use idempotency when retrying could create duplicate side effects, especially for payments, resource creation, message dispatch, and webhook-triggered operations.

Use provider-supported idempotency keys where available and application-level protection where necessary.
## Background jobs

External work that need not finish during the request cycle should use Active Job/Solid Queue.

Jobs should call services. Provider SDK orchestration remains in the provider layer.
