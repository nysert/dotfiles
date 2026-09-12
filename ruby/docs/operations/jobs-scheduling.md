# Jobs Scheduling

Detailed guidance referenced by `docs/operations.md`. Read this file only when this topic is relevant to the task.

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
