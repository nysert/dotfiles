# Data Migrations

Detailed guidance referenced by `docs/database.md`. Read this file only when this topic is relevant to the task.

## Data migrations

Separate substantial backfills from ordinary schema changes when it improves deployment safety.

For large tables, batch updates, avoid loading everything into memory, keep transactions appropriately sized, and make work resumable when practical.
## Destructive changes

Treat dropping columns/tables, renames, and type changes as high-risk.

Prefer staged changes when rolling deployments may temporarily run old and new application versions.
## Completion checklist

- [ ] New primary keys use UUIDv7 unless an exception is justified.
- [ ] UUID foreign-key types match referenced columns.
- [ ] Important relations have database foreign keys.
- [ ] Required fields use appropriate null constraints.
- [ ] Uniqueness invariants have unique indexes.
- [ ] Indexes correspond to real query patterns.
- [ ] N+1 behavior was considered.
- [ ] Atomic multi-write workflows use transactions.
- [ ] Concurrency-sensitive invariants are database-protected.
- [ ] Raw SQL, if any, is parameterized.
- [ ] Large-table migration impact was considered.
- [ ] PostgreSQL-version-specific functionality was verified.
