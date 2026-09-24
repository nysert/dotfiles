# Operations Guidelines

Use this file when modifying environment configuration, workers, queues, scheduled work, runtime behavior, or deployment-sensitive settings.

## Core rules

- Use the project's existing configuration mechanism.
- Validate required environment configuration during startup rather than failing much later during a request or job.
- Never commit secrets.
- Do not provide insecure default production credentials.
- Keep business logic out of worker/job wrappers.
- Delegate jobs to application/service modules.
- Make retryable background work idempotent.
- Use bounded retries with appropriate backoff for transient failures.
- Set explicit timeouts for external I/O.
- Handle graceful shutdown.
- Stop accepting new work before terminating.
- Allow bounded in-flight work to complete when appropriate.
- Treat unhandled promise rejections and uncaught exceptions as process-health failures.
- Do not silently continue when process state may be invalid.
- Use intentional time zones for scheduled work.
- Avoid introducing new queue, scheduler, or orchestration infrastructure unless the existing stack cannot reasonably satisfy the requirement.
- Preserve compatibility with the repository's supported Node.js version and deployment environment.

## Deployment-sensitive changes

When changing startup, shutdown, database migrations, workers, ports, health checks, environment variables, build output, or runtime version, verify the deployment/runtime path in addition to normal tests.
