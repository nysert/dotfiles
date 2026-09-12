# Runtime Deployments

Detailed guidance referenced by `docs/operations.md`. Read this file only when this topic is relevant to the task.

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
