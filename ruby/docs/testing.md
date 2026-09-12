# Testing Guidelines

Use this file when adding or changing application behavior.

Follow the testing framework and patterns already used by the application. Test public behavior rather than private implementation details.

## Core rules

- Add or update tests for behavior changed by the task.
- Prefer coverage of user-visible behavior, public service behavior, persistence changes, authorization boundaries, error handling, and important business rules.
- Do not tightly couple tests to private helper methods or incidental implementation details.
- Run the narrowest relevant test first, then expand to the affected area and broader completion checks.
- Do not fix unrelated existing failures unless required for the task.

## Read when relevant

- Service, controller/request, model, and system-test guidance → `docs/testing/layers.md`
- Working strategy, standard commands, and completion checklist → `docs/testing/workflow.md`

## Standard completion checks

For Ruby changes, normally run:

```sh
bin/rubocop
bin/rails test
```

For relevant user-facing behavior, also run `bin/rails test:system` where appropriate.
