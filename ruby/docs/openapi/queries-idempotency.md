# Queries Idempotency

Detailed guidance referenced by `docs/openapi.md`. Read this file only when this topic is relevant to the task.

# Pagination

Use one pagination convention consistently.

Example:

```text
?page=1&per_page=25
```

Collection response:

Long example moved to `docs/openapi/examples.md` → **Pagination — example 1**.

Define pagination parameters and metadata as reusable components.

Set reasonable limits on `per_page`.

---
# Filtering and sorting

Use predictable query parameters.

Examples:

```text
?status=confirmed
?sort=created_at
?sort=-created_at
```

Document:

- Supported filters.
- Supported sort fields.
- Default sort.
- Invalid-value behavior.

Do not silently support undocumented filters as part of the public contract.

---
# Idempotency

Document idempotency behavior for side-effecting operations when duplicate
requests could be harmful.

Examples include:

- Payment creation.
- External resource creation.
- Message dispatch.
- Certain POST operations.

If the API accepts an idempotency key, define the header once as a reusable
OpenAPI parameter.

---
