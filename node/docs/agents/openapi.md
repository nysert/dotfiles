# OpenAPI and Public API Guidelines

Use this file when creating or changing public HTTP API contracts, schemas, responses, errors, versioning, pagination, or OpenAPI.

## Core rules

- Treat the public API contract as a compatibility boundary.
- Keep runtime validation and documented schemas aligned.
- Prefer explicit request and response schemas over ad-hoc objects.
- Use stable machine-readable error shapes and error codes.
- Do not leak stack traces, internal exception classes, SQL errors, or sensitive provider payloads.
- Use HTTP status codes consistently.
- Make pagination semantics explicit and stable.
- Design mutating endpoints for idempotency when clients may safely retry them.
- Avoid silently changing a field's meaning or type in an existing API version.
- Additive changes are generally safer than removing or renaming fields, but still require compatibility review.
- Keep generated OpenAPI output deterministic and reviewable when the project generates its specification.

## Completion

For API changes, test successful behavior and important validation/error cases, then run the project's OpenAPI generation or validation command when one exists.
