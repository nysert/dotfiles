# Workflows and Boundaries

Read when building multi-step application behavior.

- Validate incoming HTTP, CLI, queue, and message data at the boundary.
- Keep workflows in focused modules/functions with explicit inputs, outputs, and failure results.
- Inject concrete dependencies or small boundary traits instead of using service-locator globals.
- State transaction scope and side-effect ordering; a database rollback cannot undo an external HTTP call.
- Make retries and idempotency explicit for queued work and external requests.
- Translate domain errors to protocol or CLI representations at the outer layer.
- Test public workflow behavior and meaningful failures; mock only external or nondeterministic boundaries.
