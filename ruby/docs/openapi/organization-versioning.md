# Organization Versioning

Detailed guidance referenced by `docs/openapi.md`. Read this file only when this topic is relevant to the task.

# File organization

Keep the OpenAPI DSL outside `app/`.

Application code belongs under `app/`; API contract definitions do not.

Recommended structure:

Long example moved to `docs/openapi/examples.md` → **File organization — example 1**.

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
# Operation IDs

Use stable operation IDs based on resource and action.

Examples:

Long example moved to `docs/openapi/examples.md` → **Operation IDs — example 2**.

Do not derive client behavior from arbitrary generated operation IDs.

Changing an operation ID may be breaking for generated clients.

---
