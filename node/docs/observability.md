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
