# Testing Guidelines

Use this file when adding or changing application behavior.

Follow the testing framework and patterns already used by the application.

Test public behavior rather than private implementation details.

## Core rules

- Add or update tests for behavior changed by the task.
- Prefer coverage of public service behavior.
- Prefer coverage of API behavior.
- Test persistence changes where relevant.
- Test authorization boundaries.
- Test important error handling.
- Test important business rules.
- Do not tightly couple tests to private helper functions or incidental implementation details.
- Prefer deterministic tests.
- Control time, randomness, environment, and external I/O when relevant.
- Mock or fake external systems at explicit boundaries.
- Avoid mocking deep internal implementation details.
- Keep unit tests fast.
- Use integration and end-to-end tests where they provide meaningful confidence across boundaries.
- Run the narrowest relevant test first.
- Expand to the affected test area before completion.
- Do not fix unrelated existing failures unless required for the task.

## Read when relevant

- Working strategy and completion checklist → `docs/testing/workflow.md`
