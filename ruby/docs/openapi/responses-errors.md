# Responses Errors

Detailed guidance referenced by `docs/openapi.md`. Read this file only when this topic is relevant to the task.

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

Long example moved to `docs/openapi/examples.md` → **Success response envelope — example 1**.

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

Long example moved to `docs/openapi/examples.md` → **Validation errors — example 2**.

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
# HTTP status codes

Use status codes consistently.

Recommended defaults:

Long example moved to `docs/openapi/examples.md` → **HTTP status codes — example 3**.

Do not return `200` with an error object for normal API failures.

---
