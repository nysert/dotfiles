# Runtime and Operations

Read for configuration, async runtimes, workers, scheduling, deployment, or resources.

- Reuse the project's configuration loading and secret-management approach.
- Validate required settings at startup with actionable, non-sensitive failures.
- Bound connection pools, concurrency, channels, queues, and memory-heavy work.
- Respect graceful shutdown and resource cleanup.
- Use repeatable builds and follow toolchain and lockfile policy.
- Keep migrations, startup, and job processing safe for the actual deployment topology.
- Do not change process architecture or deploy strategy during unrelated feature work.

## Read when relevant

- Worker lifecycle, cancellation, queue bounds, shutdown → `docs/agents/operations/workers-shutdown.md`
