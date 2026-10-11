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

## Grafana Cloud: default debugging workflow

- Preserve the project's Rust `tracing` ecosystem. Attach a compatible OpenTelemetry layer and OTLP exporter to the **existing** subscriber for **Grafana Cloud Tempo**; avoid double subscriber initialization. In loco.rs, inspect the installed version/logger hook and configure inbound HTTP spans, SQL client instrumentation, and W3C propagation deliberately.
- Ship ordinary structured stdout logs separately through a collector such as **Grafana Alloy → Grafana Cloud Loki**. Rust `tracing` macros alone do not export logs or spans to Grafana. Include stable service/environment/version metadata; correlate logs using active `trace_id`/`span_id`, not high-cardinality Loki labels.
- Find slow requests via **Explore → Tempo** waterfalls, then inspect service/time/trace-ID logs in **Explore → Loki**. Investigate SQL statistics/plans with `pg_stat_statements` and `EXPLAIN` directly.
- Protect secrets, user data, SQL values, and tokens; keep exporter failure nonfatal and flush providers on graceful shutdown. Prefer plain Grafana Cloud Free signals over host-billed Application Observability / Database Observability. Do not fabricate live Grafana results.

