# Database Guidelines

Use this file when creating or modifying migrations, Active Record persistence, indexes, constraints, PostgreSQL queries, transactions, locking, or data migrations.

PostgreSQL is the application's database.

## Core principles

Prefer:

- PostgreSQL-native data integrity.
- Active Record for ordinary application queries.
- Database constraints for important invariants.
- Deliberate indexes based on real access patterns.
- UUIDv7 for new application-owned primary keys.
- Transactions for atomic workflows.
- Simple normalized schemas by default.
- Measured optimization rather than speculative indexing.

## UUIDv7 primary keys

Use UUIDv7 for new application-owned primary keys unless an existing table or external constraint requires another strategy.

UUIDv7 is preferred because it keeps UUID-style decentralized IDs while providing better time ordering and index locality than random UUIDv4 values.

Use PostgreSQL `uuid` columns for UUIDv7 values.

Foreign keys referencing UUIDv7 primary keys must also use `uuid`.

Do not convert existing primary keys solely for consistency unless explicitly requested.

Use one consistent UUIDv7 generation strategy across the project. Prefer database-native UUIDv7 generation when the deployed PostgreSQL version supports the chosen function and the project has intentionally adopted it. Otherwise use the project's established Ruby/Rails UUIDv7 generator.

Do not scatter UUID generation logic throughout models and services.

Before relying on a PostgreSQL UUIDv7 function, verify that the deployed PostgreSQL version supports it.

## Migrations

Migrations should be focused, reversible when practical, and safe for the expected production data size.

Do not edit already-applied migrations to change production schema behavior; create a new migration.

Avoid unrelated cleanup in task-specific migrations.

## Foreign keys

Use database foreign keys for relational integrity unless a concrete architecture constraint prevents it.

Example:

```ruby
add_reference :appointments, :user, type: :uuid, null: false, foreign_key: true
```

Do not rely only on Active Record associations.

## Null and uniqueness constraints

Use `null: false` when absence is invalid at the database level.

When uniqueness matters for correctness, use a unique database index in addition to Rails validation.

Rails uniqueness validation alone does not prevent concurrent duplicate writes.

## Check constraints

Use PostgreSQL check constraints for simple invariants the database can reliably enforce, such as positive values or valid ranges.

Do not encode complex workflows in check constraints.

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
