# Workflow

Detailed guidance referenced by `docs/testing.md`. Read this file only when this topic is relevant to the task.

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
