# Database Guidelines

Use this file when changing persistence, schemas, migrations, indexes, constraints, queries, transactions, locking, or data migrations.

## Core rules

- Follow the ORM, query builder, and database library already selected by the project.
- Treat committed migrations as append-only history once they may have been applied.
- Do not rewrite applied migrations unless the project explicitly permits it.
- Prefer database constraints for invariants the database can enforce reliably.
- Add indexes intentionally for actual query/access patterns.
- Use parameterized queries or the database library's safe query API.
- Never interpolate untrusted values into raw SQL.
- Use transactions for workflows that must succeed or fail atomically.
- Keep transactions as short as practical.
- Avoid unnecessary external network calls while a database transaction is open.
- Be explicit about concurrency when read-modify-write behavior can race.
- Avoid N+1 query patterns.
- Avoid accidental full-table scans.
- Review query plans for performance-sensitive or high-volume queries.
- Make destructive or data migrations safe for the expected data size and deployment model.
- Do not change unrelated schema or data as incidental cleanup.

## Completion

Run the narrowest relevant database tests plus the project's normal lint, type, and test checks.

When a migration changes production data or a large table, verify rollout and rollback expectations before completion.
