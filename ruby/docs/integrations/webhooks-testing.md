# Webhooks Testing

Detailed guidance referenced by `docs/integrations.md`. Read this file only when this topic is relevant to the task.

## Webhooks

Webhook endpoints must:

1. Verify provider signatures when supported.
2. Parse events safely.
3. Deduplicate using stable provider event IDs when possible.
4. Acknowledge quickly.
5. Move substantial processing into jobs/services.

Do not trust a webhook merely because it reaches a secret-looking URL.
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
