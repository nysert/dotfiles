# Schemas Types

Detailed guidance referenced by `docs/openapi.md`. Read this file only when this topic is relevant to the task.

# Application-side response serialization

Keep API response/error serialization under `app/services`.

Do not introduce new top-level directories under `app`.

A reasonable structure is:

```text
app/services/
└── api/
    ├── response.rb
    └── errors/
        ├── serialize.rb
        └── validation.rb
```

For example:

```text
Api::Errors::Validation
```

may convert Active Model errors into the documented API structure.

Controllers should not each implement their own error serialization format.

---
# Shared OpenAPI schemas

Define repeated structures once.

Recommended shared schemas include:

```text
Error
FieldError
ValidationError
Pagination
```

Resource schemas may include:

```text
User
Appointment
Service
Subscription
```

Endpoint files should reference shared schemas rather than redefining them.

Avoid large repeated inline schemas.

---
# Shared OpenAPI responses

Common failures should be reusable response components where practical.

Examples:

```text
BadRequest
Unauthorized
Forbidden
NotFound
ValidationFailed
RateLimited
InternalError
```

Endpoint definitions should reference these common response structures.

Only define endpoint-specific error schemas when the endpoint genuinely has
additional contract requirements.

---
# Authentication

Document the authentication scheme once as a shared OpenAPI security component.

Endpoint files should reference it.

Do not duplicate bearer/API-key definitions in every endpoint.

Explicitly mark public endpoints as public when the DSL requires it.

---
# Request schemas

Define request bodies as schemas/components when reused or meaningfully complex.

Do not document writable fields merely by reusing the complete response schema.

Request and response representations often differ.

For example:

```text
CreateUserRequest
UpdateUserRequest
User
```

may be separate schemas.

This makes required/write-only/read-only behavior explicit.

---
# Optional versus nullable

Treat optional and nullable as different concepts.

Optional:

```text
The key may be omitted.
```

Nullable:

```text
The key may be present with null.
```

Document this intentionally.

Do not make fields nullable merely because they are optional.

---
# IDs

Application-owned resource IDs are UUIDv7 values stored as UUIDs.

Document them as:

```yaml
type: string
format: uuid
```

Do not expose assumptions that clients can infer creation order or timestamps
from UUIDv7 identifiers as part of the API contract.

The UUID remains an opaque resource identifier to API consumers.

---
# Dates and timestamps

Use ISO 8601 representations.

Document timestamps using:

```yaml
type: string
format: date-time
```

Prefer UTC timestamps in API responses unless a domain requirement explicitly
requires another representation.

Do not return locale-formatted date strings as API values.

---
