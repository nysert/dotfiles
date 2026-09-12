# Integration Guidelines

Use this file when the application communicates with third-party APIs or providers such as payments, email, SMS, WhatsApp, AI/LLM providers, storage, search, maps, or other external services.

All application-side integration code belongs under `app/services/`.

## Core rules

- Application workflows should depend on stable internal concepts, not directly on provider SDK details.
- Isolate provider-specific behavior so providers can be switched with minimal application changes when portability matters.
- Do not create new top-level `app/clients`, `app/adapters`, `app/gateways`, or `app/integrations` directories.
- Keep provider interfaces small; do not wrap an entire SDK one-for-one.
- Centralize credentials/provider selection.
- Normalize provider-specific responses and errors at the boundary.
- Every network integration needs explicit timeouts.
- Retry only transient failures, with bounded retries/backoff.
- Use idempotency where retries could duplicate side effects.

## Read when relevant

- Service/provider structure, interfaces, selection, credentials, normalization, errors → `docs/integrations/providers.md`
- Timeouts, retries, idempotency, and background execution → `docs/integrations/reliability.md`
- Webhooks, integration testing, provider switching, and completion checks → `docs/integrations/webhooks-testing.md`
- Long concrete examples → `docs/integrations/examples.md`
