# Testing Guidelines

Use this file when adding or changing application behavior.

Follow the testing framework and patterns already used by the application.

Test behavior rather than private implementation details.

---

## General principles

Add or update tests for behavior changed by the task.

Prefer tests that verify:

- User-visible behavior.
- Public service behavior.
- Persistence changes.
- Authorization boundaries.
- Error handling.
- Important business rules.

Avoid tests that tightly couple themselves to private helper methods or incidental implementation details.

---

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

## Working strategy

While implementing a change:

1. Run the narrowest relevant test first.
2. Iterate using focused tests.
3. Expand to the affected test area.
4. Run broader checks before completion.

This keeps feedback fast without skipping broader validation.

---

## Standard completion checks

For Ruby changes, normally run:

```sh
bin/rubocop
bin/rails test
```

For relevant user-facing behavior, also run:

```sh
bin/rails test:system
```

If the full suite is unusually expensive, run the broadest practical affected test set and clearly report what was and was not run.

Do not fix unrelated existing test or RuboCop failures unless required for the requested task.

---

## Test quality checklist

Before considering behavior changes complete, verify:

- [ ] Changed behavior has appropriate coverage.
- [ ] Tests focus on public behavior.
- [ ] Important failure paths are covered.
- [ ] Meaningful service logic has service tests.
- [ ] User-facing behavior has system coverage where appropriate.
- [ ] Relevant focused tests pass.
- [ ] Broader required checks were run.
- [ ] Unrelated failures were not silently modified.
