# Observability Guidelines

Use this file when changing logs, error reporting, metrics, tracing, or production diagnostics.

## Core rules

- Prefer structured logs when the logging stack supports them.
- Include stable operational context such as request IDs, job IDs, operation names, and relevant entity IDs.
- Do not log secrets, credentials, authorization headers, session tokens, payment data, or unnecessary personal information.
- Log failures at the layer that can add meaningful operational context.
- Avoid duplicate log-and-rethrow noise.
- Preserve error causes and stacks when reporting wrapped failures.
- Use metrics for aggregate behavior.
- Do not encode unbounded identifiers as metric labels.
- Propagate trace or correlation context through HTTP calls, jobs, and provider boundaries when supported.
- Keep high-volume success logs intentional.
- Add observability around retries, dropped work, queue latency, external-provider failures, and critical background workflows.

Observability should make it possible to answer what failed, where, during which operation, for which request/job/entity, and whether recovery occurred without exposing sensitive data.

## Grafana Cloud: default debugging workflow

- Initialize a compatible Node OpenTelemetry SDK **before framework and DB imports**; send supported HTTP, database, and worker spans through OTLP to **Grafana Cloud Tempo**. Keep the existing logger and ship structured stdout separately through a collector such as **Grafana Alloy → Grafana Cloud Loki**. Traces alone do not send console/Docker logs.
- Use consistent service/environment/version attributes; propagate W3C trace context through HTTP and async calls. Add active `trace_id`/`span_id` to logs when possible, never as indexed Loki labels. Add narrow custom spans only for meaningful missing operations.
- Debug in **Explore → Tempo** by service and latency; view waterfalls and SQL spans; search **Explore → Loki** by service/time/trace ID when logs are collected. Database plans come from native SQL tools, not ordinary trace spans.
- Never export secrets, HTTP authorization headers, SQL bind values, or raw private bodies. Prefer standard Grafana Cloud Free telemetry over host-billed curated Application Observability / Database Observability; do not invent Grafana findings when access is unavailable.

