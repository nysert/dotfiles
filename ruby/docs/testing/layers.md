# Layers

Detailed guidance referenced by `docs/testing.md`. Read this file only when this topic is relevant to the task.

## Services

Services containing meaningful business logic should generally have corresponding tests.

Test the service through its public API, normally:

```ruby
#call
```

Cover relevant:

- Success paths.
- Validation failures.
- Persistence changes.
- Transaction behavior.
- External integration boundaries.
- Important edge cases.

Do not test private methods directly unless the existing project explicitly follows that pattern.

---
## Controllers

Controller/request tests should focus on HTTP behavior such as:

- Authentication.
- Authorization.
- Status codes.
- Redirects.
- Rendered responses.
- Parameter handling.
- Delegation effects visible through public behavior.

Do not duplicate detailed service behavior in controller tests.

---
## Models

Test:

- Important validations.
- Associations when behavior depends on them.
- Scopes with meaningful logic.
- Intrinsic model behavior.
- Important persistence invariants.

Avoid low-value tests that merely restate Rails defaults without protecting meaningful application behavior.

---
## System tests

Use system tests for important user flows and UI behavior.

When changing user-facing behavior, run relevant system tests where they exist.

Typical command:

```sh
bin/rails test:system
```

---
