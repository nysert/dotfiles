# External Integrations

Read for provider HTTP APIs, SDKs, webhooks, or external I/O.

Put all new application-side integration implementations under `src/services/<domain>/`, with provider-specific implementations under `src/services/<domain>/providers/`. Do not create top-level integration, client, gateway, or adapter directories for this purpose.

- Keep workflows in application terms. Isolate SDKs and provider request and response formats, and normalize results and errors at the boundary.
- Centralize credentials and provider selection. Keep application-owned interfaces small. A one-off integration can use its domain-local provider directly from the workflow without a separate gateway or trait.
- Reuse existing clients, connection pools, and configuration.
- Set explicit timeouts, bound payload sizes, and map network failures with useful context.
- Parse untrusted provider data into validated structures.
- Keep tokens and sensitive payloads out of logs and error messages.
- Retry only transient failures with bounded retries and backoff. Respect rate limits and use idempotency when retries can duplicate side effects.
- Preserve existing provider contracts and test successful, malformed, timeout, and outage responses.

## Read when relevant

- Provider layout, interfaces, selection, credentials, and normalization → `docs/agents/integrations/providers.md`
- Retries, backoff, webhooks, delivery → `docs/agents/integrations/reliability.md`
