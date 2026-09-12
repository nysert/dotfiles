# Schema Migrations

Detailed guidance referenced by `docs/database.md`. Read this file only when this topic is relevant to the task.

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
