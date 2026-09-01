# OpenAPI Guidelines

Use this file when creating or modifying API endpoints, request/response schemas,
authentication, API errors, versioning, pagination, or OpenAPI documentation.

The OpenAPI contract and Rails implementation must stay synchronized.

Do not keep the entire API DSL in one large Ruby file.

---

# Core principles

Prefer:

- A versioned API.
- One OpenAPI endpoint file per Rails-style action.
- Shared schemas/components for repeated structures.
- Consistent success and error envelopes.
- Stable machine-readable error codes.
- Backward-compatible changes whenever practical.
- Reusable request/response schemas rather than duplicated inline definitions.

The OpenAPI specification describes the external contract, not internal implementation details.

---

# File organization

Keep the OpenAPI DSL outside `app/`.

Application code belongs under `app/`; API contract definitions do not.

Recommended structure:

```text
openapi/
├── openapi.rb
├── components/
│   ├── parameters/
│   │   └── pagination.rb
│   ├── responses/
│   │   ├── bad_request.rb
│   │   ├── forbidden.rb
│   │   ├── not_found.rb
│   │   ├── rate_limited.rb
│   │   ├── unauthorized.rb
│   │   └── validation_failed.rb
│   └── schemas/
│       ├── error.rb
│       ├── field_error.rb
│       ├── pagination.rb
│       ├── user.rb
│       └── appointment.rb
└── v1/
    ├── users/
    │   ├── index.rb
    │   ├── show.rb
    │   ├── create.rb
    │   ├── update.rb
    │   └── destroy.rb
    └── appointments/
        ├── index.rb
        ├── show.rb
        ├── create.rb
        ├── update.rb
        ├── destroy.rb
        └── cancel.rb
```

`openapi/openapi.rb` should contain only global specification information and
load/register the modular component and endpoint files.

It should not become the place where every endpoint is defined.

---

# Endpoint filenames

Prefer Rails-style action names:

```text
index.rb
show.rb
create.rb
update.rb
destroy.rb
```

For real domain actions that are not ordinary CRUD operations, use the action name:

```text
cancel.rb
publish.rb
archive.rb
resend.rb
```

Prefer:

```text
openapi/v1/appointments/create.rb
openapi/v1/appointments/cancel.rb
```

over files named only after HTTP methods:

```text
post.rb
patch.rb
```

The resource directory plus action name communicates intent more clearly.

The HTTP method remains defined inside the endpoint contract.

---

# API versioning

Version public API paths.

Prefer:

```text
/api/v1/users
/api/v1/appointments
```

Keep matching OpenAPI definitions under:

```text
openapi/v1/
```

A new API version should get a separate version directory when incompatible
contract changes require it.

Do not create a new version for ordinary additive backward-compatible changes.

---

# REST conventions

Prefer conventional REST endpoints.

Example:

```text
GET    /api/v1/appointments
GET    /api/v1/appointments/{id}
POST   /api/v1/appointments
PATCH  /api/v1/appointments/{id}
DELETE /api/v1/appointments/{id}
```

Avoid RPC-style routes for ordinary CRUD:

```text
POST /api/v1/create_appointment
POST /api/v1/update_appointment
```

Domain actions are acceptable when they represent real operations:

```text
POST /api/v1/appointments/{id}/cancel
POST /api/v1/articles/{id}/publish
```

---

# Success response envelope

Use a consistent top-level `data` key for successful responses.

Single-resource example:

```json
{
  "data": {
    "id": "0195f7b7-6c62-7e24-bd60-c0a59b7846af",
    "email": "user@example.com",
    "username": "example"
  }
}
```

Collection example:

```json
{
  "data": [
    {
      "id": "0195f7b7-6c62-7e24-bd60-c0a59b7846af",
      "email": "one@example.com"
    },
    {
      "id": "0195f7b9-23d9-7bb6-b24f-c1803be82b5e",
      "email": "two@example.com"
    }
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 25,
      "total_pages": 4,
      "total_count": 88
    }
  }
}
```

Use `meta` only when additional response metadata is useful.

Do not add redundant fields such as:

```json
{
  "success": true
}
```

when the HTTP status already communicates success.

---

# Error response envelope

All API errors should use a consistent top-level `error` object.

General example:

```json
{
  "error": {
    "code": "not_found",
    "message": "Appointment not found."
  }
}
```

`code` is stable and machine-readable.

`message` is human-readable and may evolve without being treated as an API identifier.

Clients should depend on `code`, not exact `message` text.

---

# Validation errors

Validation failures must support:

- Multiple invalid fields.
- Multiple errors on the same field.
- Stable machine-readable codes for each field error.

Use:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "One or more fields are invalid.",
    "fields": {
      "email": [
        {
          "code": "taken",
          "message": "has already been taken"
        },
        {
          "code": "invalid",
          "message": "is invalid"
        }
      ],
      "username": [
        {
          "code": "too_short",
          "message": "is too short",
          "meta": {
            "minimum": 3
          }
        }
      ]
    }
  }
}
```

Each field maps to an array, even when only one error is present.

Good:

```json
{
  "email": [
    {
      "code": "taken",
      "message": "has already been taken"
    }
  ]
}
```

Do not switch between an object and an array based on the number of errors.

This keeps the response shape stable.

---

# Field error schema

A field error should contain:

```json
{
  "code": "too_short",
  "message": "is too short"
}
```

It may optionally include machine-readable metadata:

```json
{
  "code": "too_short",
  "message": "is too short",
  "meta": {
    "minimum": 3
  }
}
```

Use `meta` for useful structured information such as:

- Minimum length.
- Maximum length.
- Allowed values.
- Minimum/maximum numeric values.

Do not require clients to parse human-readable messages to obtain these values.

---

# Rails validation mapping

Preserve all Active Model validation errors.

Do not use APIs such as:

```ruby
record.errors.to_hash
```

in a way that accidentally collapses or loses structured error information.

A suitable application-side mapping can use:

```ruby
record.errors.group_by_attribute.transform_values do |errors|
  errors.map do |error|
    {
      code: error.type.to_s,
      message: error.message,
    }
  end
end
```

This naturally preserves multiple errors on the same attribute.

If useful validation metadata exists in `error.options`, normalize only the
safe and relevant values into `meta`.

Do not expose internal or sensitive validation options blindly.

---

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

# HTTP status codes

Use status codes consistently.

Recommended defaults:

```text
200 OK                    successful read/update/action
201 Created               successful resource creation
204 No Content            successful deletion with no response body

400 Bad Request           malformed request or invalid request structure
401 Unauthorized          missing/invalid authentication
403 Forbidden             authenticated but not permitted
404 Not Found             resource does not exist or is intentionally hidden
409 Conflict              request conflicts with current resource state
422 Unprocessable Entity  semantic/validation failure
429 Too Many Requests     rate limited
500 Internal Server Error unexpected server failure
```

Do not return `200` with an error object for normal API failures.

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

# Pagination

Use one pagination convention consistently.

Example:

```text
?page=1&per_page=25
```

Collection response:

```json
{
  "data": [],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 25,
      "total_pages": 0,
      "total_count": 0
    }
  }
}
```

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

# Backward compatibility

Before changing an existing API contract, determine whether the change is
backward-compatible.

Usually safe:

- Adding an optional response field.
- Adding an optional request field.
- Adding a new endpoint.
- Adding a new optional filter.

Potentially breaking:

- Removing a field.
- Renaming a field.
- Changing a field type.
- Making an optional field required.
- Changing status codes.
- Changing error codes.
- Changing enum semantics.
- Changing pagination semantics.

Do not make a breaking change silently.

Use a new API version when compatibility cannot reasonably be preserved.

---

# Examples

Provide realistic examples for:

- Request bodies.
- Successful responses.
- Validation failures.
- Important domain errors.

Examples must match the actual schemas.

Do not use real credentials, production data, or sensitive information.

---

# OpenAPI endpoint file checklist

Each endpoint file should clearly define:

- HTTP method.
- Path.
- Operation ID.
- Summary/description.
- Authentication requirements.
- Path/query/header parameters.
- Request body where applicable.
- Success responses.
- Relevant error responses.
- Referenced schemas/components.

Keep endpoint files focused on that endpoint.

Move repeated schemas/responses into `openapi/components/`.

---

# Operation IDs

Use stable operation IDs based on resource and action.

Examples:

```text
users.index
users.show
users.create
users.update
users.destroy

appointments.index
appointments.show
appointments.create
appointments.update
appointments.cancel
```

Do not derive client behavior from arbitrary generated operation IDs.

Changing an operation ID may be breaking for generated clients.

---

# Build and validation

The project should have one command that builds/generates the complete
OpenAPI document from the modular Ruby definitions.

It should also have one command that validates/lints the generated contract.

The generated OpenAPI artifact should be deterministic.

Do not manually edit a generated `openapi.json` or `openapi.yaml` when Ruby DSL
files are the source of truth.

Make changes in the source DSL and regenerate.

---

# Completion checklist

Before considering API work complete, verify:

- [ ] The Rails implementation and OpenAPI contract agree.
- [ ] The endpoint lives in the correct `openapi/vN/<resource>/<action>.rb` file.
- [ ] Shared structures are referenced instead of duplicated.
- [ ] Successful responses use the standard `data` envelope.
- [ ] Errors use the standard `error` envelope.
- [ ] Validation errors support multiple fields.
- [ ] Every field maps to an array of errors.
- [ ] Multiple errors on the same field are preserved.
- [ ] Error codes are stable and machine-readable.
- [ ] HTTP status codes are appropriate.
- [ ] Optional versus nullable is intentional.
- [ ] UUID resource IDs are documented as UUID strings.
- [ ] Authentication is documented.
- [ ] Pagination/filter/sort behavior is documented where applicable.
- [ ] Backward compatibility was considered.
- [ ] Examples contain no sensitive data.
- [ ] Generated OpenAPI output was rebuilt and validated.

## Core rule

**Endpoint definitions should be small; shared contracts should be centralized.**

The OpenAPI source should scale by adding files, not by growing one giant DSL file.
