# External Integrations

Read for provider HTTP APIs, SDKs, webhooks, or external I/O.

- Reuse existing clients, connection pools, and configuration.
- Set timeouts, bound payload sizes, and map network failures with useful context.
- Parse untrusted provider data into validated structures.
- Keep tokens and sensitive payloads out of logs and error messages.
- Do not retry every failure; consider rate limits, idempotency, and partial side effects.
- Preserve existing provider contracts and test successful, malformed, timeout, and outage responses.

## Read when relevant

- Retries, backoff, webhooks, delivery → `docs/agents/integrations/reliability.md`
