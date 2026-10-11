# Database Guidelines

Read for SQL, migrations, persistence, locking, or transaction changes.

- Reuse the existing database driver, ORM/query library, and migration system.
- Use parameterized statements, explicit mapping, and appropriate constraints.
- Prefer database-enforced correctness for uniqueness and referential integrity.
- Design migrations for the project's actual deployment/rollback expectations.
- Avoid unbounded queries, N+1 access, oversized batches, and long transactions.
- Inspect query plans for performance-sensitive changes and weigh index write costs.
- Treat transaction isolation, locking, and concurrent writers as correctness concerns.
- Test meaningful persistence behavior against the real database engine when possible.

## Read when relevant

- SQL performance, transactions, races, migrations → `docs/agents/database/queries-concurrency.md`
