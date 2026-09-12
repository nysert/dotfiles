# Database Guidelines

Use this file when creating or modifying migrations, Active Record persistence, indexes, constraints, PostgreSQL queries, transactions, locking, or data migrations.

PostgreSQL is the application's database.

## Core rules

- Prefer PostgreSQL-native data integrity and Active Record for ordinary application queries.
- Use database constraints for important invariants.
- Add indexes deliberately from real access patterns; measure before speculative optimization.
- Use UUIDv7 for new application-owned primary keys unless an existing constraint requires another strategy.
- Use transactions for atomic workflows and keep them short.
- Assume concurrent requests/jobs may modify the same records.
- Prefer normalized schemas by default.
- Parameterize all untrusted values when raw SQL is necessary.

## Read when relevant

- UUIDv7, migrations, foreign keys, uniqueness, and check constraints → `docs/database/schema-migrations.md`
- Indexes, queries, N+1s, transactions, locking, JSONB, enums, time/money → `docs/database/queries-concurrency.md`
- Data migrations, destructive changes, and completion checks → `docs/database/data-migrations.md`
