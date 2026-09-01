# Operations Guidelines

Use this file when modifying configuration, Rails credentials, background processing, scheduled work, recurring jobs, production runtime behavior, or deployment-sensitive settings.

## Core principles

Prefer:

- Rails credentials for secrets.
- Environment variables for appropriate runtime configuration.
- Active Job with Solid Queue for background work.
- Solid Queue recurring tasks for application scheduled jobs.
- Existing deployment/process management before introducing new infrastructure.

## Rails credentials

Use Rails credentials for API keys, signing secrets, encryption secrets, provider tokens, and other sensitive values.

Do not create a parallel secrets system without a concrete requirement.

Never commit decrypted credentials or real secrets.

## Credentials vs environment variables

Prefer credentials for secrets.

Use environment variables for runtime/environment configuration such as hostnames, ports, process counts, log level, and non-secret deployment toggles.

Do not put every non-secret value in encrypted credentials.

## Background jobs

Use Active Job with Solid Queue.

Jobs should receive arguments, call an application service, and own only job-specific queue/retry behavior.

Keep business logic in `app/services`.

## Queue design

Use a small set of meaningful queues based on operational differences such as priority, concurrency, resource requirements, or failure isolation.

Do not create a queue for every job class.

## Scheduled and recurring jobs

Use Solid Queue recurring tasks for application-owned schedules.

Prefer the project's recurring configuration, typically `config/recurring.yml`.

Scheduled entries should invoke jobs/services rather than contain business logic.

Follow the exact Solid Queue syntax supported by the project version.

## Cron

If host/system cron is needed, keep its role minimal.

Prefer Solid Queue recurring tasks for schedules owned by the Rails application.

Use system cron only when the task genuinely belongs outside the Rails/Solid Queue runtime, such as host-level maintenance.

Do not maintain two independent schedules for the same task.

## Time zones

Scheduled work must use an intentional time zone.

Do not assume server-local time.

For user-specific schedules, persist enough information to resolve intended local time correctly and consider DST behavior.

## Idempotency

Recurring jobs should be safe if retried, triggered twice, or restarted after partial completion.

Use database uniqueness/locking where necessary to prevent duplicate side effects.

## Long-running work

Move long-running work outside request cycles.

Process large datasets in batches, avoid loading whole tables into memory, keep transactions appropriately small, and make work resumable when practical.

## Retries

Retry transient failures with bounded retry behavior.

Do not retry permanent validation/authentication failures indefinitely.

For provider-specific retry semantics, also follow `docs/integrations.md`.

## Deployment compatibility

For deployment-sensitive changes, consider compatibility between old/new application processes, database schema, queue payloads, and scheduled jobs.

Prefer staged changes when rolling deployments can temporarily run multiple application versions.

## Infrastructure

Do not introduce new queue systems, schedulers, process managers, secret stores, or orchestration platforms unless the task requires them and the existing Rails/Solid Queue stack cannot reasonably satisfy the need.

## Health and shutdown

Health checks should be cheap and should not expose sensitive operational details.

Background work must tolerate process restarts. Avoid relying on in-memory state for critical progress.

## Completion checklist

- [ ] Secrets use Rails credentials.
- [ ] Runtime configuration uses the existing project mechanism.
- [ ] Background work uses Active Job/Solid Queue.
- [ ] Business logic remains in `app/services`.
- [ ] Recurring application jobs use Solid Queue recurring tasks when appropriate.
- [ ] Cron does not duplicate Solid Queue scheduling.
- [ ] Scheduled work uses the intended time zone.
- [ ] Recurring jobs are idempotent.
- [ ] Retry behavior is bounded.
- [ ] Long-running work is batch-safe.
- [ ] Deployment compatibility was considered.
- [ ] No unnecessary infrastructure dependency was introduced.
