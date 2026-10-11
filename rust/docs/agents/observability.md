# Observability

Read for logging, diagnostics, traces, or metrics.

- Follow the existing logging/tracing stack (e.g. `tracing`, `log`, OpenTelemetry).
- Use structured events and spans at useful request, job, and provider boundaries.
- Include stable IDs and timing data; avoid uncontrolled metric-label cardinality.
- Propagate trace context through async and outbound requests if supported.
- Keep credentials, tokens, sensitive payloads, and unnecessary personal data out of instrumentation.
- Avoid logging the same error noisily at every layer.
- Do not swallow operational failures into a log-only success path.
- Keep readiness, health, and errors meaningful to operators.
