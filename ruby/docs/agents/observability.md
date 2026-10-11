# Observability Guidelines

Use this file when adding or modifying logging, error reporting, metrics, tracing, or observability providers.

All application-side observability abstractions and provider implementations belong under `app/services/`.

## Core rules

- Use stable application-level interfaces when provider portability matters.
- Keep provider SDK details isolated and wrappers smaller than provider APIs.
- Continue using Rails logger for ordinary logs; do not route every log line through a wrapper.
- Prefer structured metadata with stable field names.
- Never include secrets or sensitive payloads in observability data.
- Do not report expected validation/auth/404 failures as exceptional errors by default.
- Keep metric labels low-cardinality.
- Add tracing where it helps diagnose meaningful cross-system or multi-step work; do not instrument every method.

## Read when relevant

- Provider wrappers, Rails logging, provider selection, failure behavior → `docs/agents/observability/providers-logging.md`
- Structured context, error reporting, events, metrics, tracing → `docs/agents/observability/signals.md`
- Sensitive-data rules, tests, and completion checks → `docs/agents/observability/security-testing.md`
- Long concrete examples → `docs/agents/observability/examples.md`

## Grafana Cloud: default debugging workflow

- Instrument Rails HTTP, supported ActiveRecord SQL, jobs, and outgoing HTTP using **OpenTelemetry OTLP → Grafana Cloud Tempo**. Use existing Rails logger for ordinary logs, sending structured stdout via a configured collector such as **Grafana Alloy → Grafana Cloud Loki**. Traces do not ship logs.
- Keep service name, deployment environment, and version stable. Attach real active `trace_id` and `span_id` to log context where supported; never turn them into Loki index labels. Preserve W3C context across HTTP boundaries. Instrument serialization and expensive domain operations when automatic spans leave genuine gaps.
- Debug using **Explore → Tempo**, filter by service/duration, open the request waterfall and SQL spans, then correlate by time/service/trace ID in **Explore → Loki**. Use PostgreSQL `pg_stat_statements` and `EXPLAIN` locally for statistics and execution plans, not a paid DB monitoring feature.
- Do not enable Grafana's host-billed Application Observability or Database Observability products incidentally. Redact headers, secrets, SQL bind values, and sensitive payloads; keep telemetry fail-open and tests independent of Grafana. Never claim to have inspected Grafana unless live data was actually available.

