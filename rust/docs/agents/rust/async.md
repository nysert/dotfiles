# Async and Concurrency

Read when modifying async functions, parallel tasks, channels, shared state, or stream processing.

- Reuse the existing runtime; do not add another merely for convenience.
- Keep blocking I/O and CPU-intensive work out of async executor threads; use the runtime's appropriate blocking path.
- Track spawned task ownership, failures, cancellation, and shutdown instead of losing errors in fire-and-forget tasks.
- Bound task concurrency, buffered channels, queues, request size, and retries.
- Define timeouts and cancellation for long-running external operations.
- Do not hold synchronous mutex guards across `.await`. Audit `Send` assumptions when spawning.
- Prefer simple ownership and message passing over shared mutable state when practical.
- Test cancellation, concurrency-sensitive invariants, overload, and graceful shutdown when relevant.

For worker lifecycle and deployment, also read `docs/agents/operations.md`.
