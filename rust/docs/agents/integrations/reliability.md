# Reliability and Webhooks

Read when changing external retries, rate limits, webhooks, or delivery guarantees.

- Define connect/request timeouts and cancellation behavior.
- Retry only transient failures, using capped backoff and jitter when appropriate.
- Respect trusted rate-limit and retry hints.
- Reuse idempotency keys and deduplicate deliveries that may occur more than once.
- Authenticate webhook senders and verify signatures against the correct raw payload where required.
- Assume at-least-once delivery unless stronger guarantees are documented.
- Test duplicate delivery, invalid signatures, partial failure, and repeated timeouts.
