# Compatibility Build

Detailed guidance referenced by `docs/openapi.md`. Read this file only when this topic is relevant to the task.

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
