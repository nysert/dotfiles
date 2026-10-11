# Queries and Concurrency

Read when changing SQL, migrations, indexes, or concurrent writes.

- Parameterize values. Allowlist any dynamic SQL identifiers rather than interpolating untrusted text.
- Use atomic updates, transactions, unique constraints, or locks to guard check-then-write workflows.
- Prefer online/safe migration strategies for large production tables when relevant.
- Evaluate index selectivity, planner use, and write overhead before adding indexes.
- Keep transactions short and bound result size, pool size, and batch size.
- If the project uses compile-time SQL validation, follow its schema/offline-metadata refresh process.
- Test conflict, rollback, duplicate, and race-sensitive behavior where applicable.
