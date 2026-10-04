# Openapi Examples

Concrete examples moved out of the topical `openapi` guidance files to keep rule context small. Read this file only when a concrete implementation example is useful.

## File organization — example 1

Source topic: `organization-versioning.md`

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

## Operation IDs — example 2

Source topic: `organization-versioning.md`

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

## Pagination — example 1

Source topic: `queries-idempotency.md`

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

## Success response envelope — example 1

Source topic: `responses-errors.md`

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

## Validation errors — example 2

Source topic: `responses-errors.md`

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

## HTTP status codes — example 3

Source topic: `responses-errors.md`

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
