# Queries Concurrency

Detailed guidance referenced by `docs/database.md`. Read this file only when this topic is relevant to the task.

## Indexes

Add indexes deliberately for common lookups, joins, uniqueness invariants, foreign keys, and important filter/sort patterns.

Do not add indexes merely because a column appears in one query.

Remember that indexes increase write cost, storage, and maintenance.

Composite index order must match real query patterns.

Use partial indexes when queries consistently target a meaningful subset.

For performance-sensitive changes, inspect plans with `EXPLAIN` / `EXPLAIN ANALYZE` when practical rather than guessing.
## Active Record queries

Prefer Active Record when it expresses the query clearly.

Use associations, scopes, joins, includes/preload/eager_load, `find_each`, and `in_batches` appropriately.

Avoid raw SQL unless Active Record materially harms clarity or capability.

When raw SQL is necessary, parameterize all untrusted values.
## N+1 queries

Check for N+1 behavior when rendering collections, serializing nested records, or accessing associations inside loops.

Eager load only what the request needs; do not blindly `includes` every association.
## Transactions

Use transactions when multiple writes must succeed or fail together.

Keep transactions as short as practical.

Do not hold a database transaction open during long external API calls unless correctness explicitly requires it.
## Concurrency and locking

Assume multiple requests/jobs can modify the same records concurrently.

Use database guarantees such as unique constraints, transactions, `with_lock`, or optimistic locking when race conditions could violate correctness.

Do not use application-only check-then-create patterns for uniqueness.
## JSONB

Use JSONB when the data is genuinely flexible.

Do not use JSONB to avoid modeling stable, frequently queried attributes as normal columns.

If JSONB properties become important query fields, consider dedicated columns or appropriate PostgreSQL indexes.
## Enums

Follow the project's existing enum strategy. Prefer simple application enums for stable finite domains unless native PostgreSQL enums provide a clear benefit.

Avoid unexplained magic strings scattered through the application.
## Time and money

Use real PostgreSQL temporal types, not formatted strings.

Do not use floating point for money. Prefer integer minor units or decimal/numeric according to the project's established convention.
