# Workflows and Boundaries

Read when building multi-step application behavior.

- Validate incoming HTTP, CLI, queue, and message data at the boundary.
- Give each workflow one coherent application action, with explicit inputs, outputs, and failure results. Use the primary function to show the high-level sequence and extract complex implementation steps into private submodules.
- Compose existing services for independently useful business actions. Keep internal steps private and share the workflow across controllers, workers, MCP tools, and CLI handlers. Avoid circular service dependencies.
- Inject concrete dependencies or small boundary traits instead of using service-locator globals.
- State transaction scope and side-effect ordering; a database rollback cannot undo an external HTTP call.
- When composing services, identify the transaction owner and pass its transaction to participating steps. Avoid holding a database transaction open during unrelated network calls or calls that can run after commit.
- Define failure handling, retry behavior, idempotency, and any compensation for queued work and external side effects.
- Translate domain errors to protocol or CLI representations at the outer layer.
- Test public workflow behavior and meaningful failures; mock only external or nondeterministic boundaries.
