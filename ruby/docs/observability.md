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

- Provider wrappers, Rails logging, provider selection, failure behavior → `docs/observability/providers-logging.md`
- Structured context, error reporting, events, metrics, tracing → `docs/observability/signals.md`
- Sensitive-data rules, tests, and completion checks → `docs/observability/security-testing.md`
- Long concrete examples → `docs/observability/examples.md`
