# Integration Guidelines

Use this file when working with third-party APIs, SDKs, providers, webhooks, messaging systems, or other external services.

## Core rules

- Put provider-specific details behind a narrow boundary instead of spreading SDK calls throughout business logic.
- Validate and normalize external data before it enters trusted application code.
- Configure explicit request timeouts.
- Retry only transient failures.
- Use bounded retries and appropriate backoff.
- Respect provider idempotency mechanisms where available.
- Make application-owned retryable operations idempotent.
- Treat webhooks as untrusted input.
- Verify webhook signatures or authenticity before processing.
- Design webhook handlers for duplicate delivery.
- Account for out-of-order delivery when the provider can produce it.
- Avoid holding database transactions open across slow external network calls unless correctness truly requires it.
- Preserve useful provider error context for observability.
- Do not expose provider secrets or sensitive payloads.
- Mock or fake provider boundaries in normal tests.
- Keep live-provider tests opt-in unless the project intentionally runs them in CI.
