# OpenAPI Guidelines

Use this file when creating or modifying API endpoints, request/response schemas, authentication, API errors, versioning, pagination, or OpenAPI documentation.

The OpenAPI contract and Rails implementation must stay synchronized.

## Core rules

- Use a versioned API.
- Keep one OpenAPI endpoint file per Rails-style action.
- Keep repeated schemas/responses/parameters in shared components.
- Successful responses use the standard `data` envelope.
- Errors use the standard `error` envelope with stable machine-readable codes.
- Validation errors must preserve multiple fields and multiple errors per field; each field maps to an array.
- Treat optional and nullable as different concepts.
- Prefer backward-compatible changes; use a new API version when incompatibility cannot reasonably be preserved.
- Keep endpoint definitions focused and centralize shared contracts.
- Generated OpenAPI output is derived from source definitions; do not manually edit generated artifacts.

## Read when relevant

- File layout, endpoint naming, versioning, REST routes, and operation IDs → `docs/openapi/organization-versioning.md`
- Success/error envelopes, validation errors, Rails mapping, and HTTP statuses → `docs/openapi/responses-errors.md`
- Serialization, shared schemas/responses, authentication, request schemas, IDs, dates, optional/nullable → `docs/openapi/schemas-types.md`
- Pagination, filtering/sorting, and idempotency → `docs/openapi/queries-idempotency.md`
- Compatibility, examples policy, endpoint checklist, build/validation, completion checks → `docs/openapi/compatibility-build.md`
- Long concrete examples → `docs/openapi/examples.md`

## Core rule

**Endpoint definitions should be small; shared contracts should be centralized.**
