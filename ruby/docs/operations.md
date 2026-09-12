# Operations Guidelines

Use this file when modifying configuration, Rails credentials, background processing, scheduled work, recurring jobs, production runtime behavior, or deployment-sensitive settings.

## Core rules

- Use the project's existing configuration mechanisms.
- Keep secrets in Rails credentials or the established secret-management path.
- Use Active Job/Solid Queue for application-owned background work.
- Keep business logic in services; jobs/schedules should invoke services rather than contain workflows.
- Prefer Solid Queue recurring tasks for schedules owned by the Rails application.
- Use intentional time zones for scheduled work.
- Make recurring/background work idempotent and safe to retry.
- Use bounded retries for transient failures.
- Avoid introducing new queue/scheduler/orchestration infrastructure unless the existing stack cannot reasonably satisfy the requirement.

## Read when relevant

- Rails credentials and runtime configuration → `docs/operations/configuration.md`
- Jobs, queues, recurring work, cron, time zones, idempotency, batching, retries → `docs/operations/jobs-scheduling.md`
- Deployment compatibility, infrastructure, health/shutdown, completion checks → `docs/operations/runtime-deployments.md`
