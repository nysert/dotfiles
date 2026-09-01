# AGENTS.md

## Project

This is a Ruby on Rails application.

Follow existing Rails conventions and project patterns unless project instructions explicitly define otherwise.

Keep changes focused on the requested task.

Do not modify unrelated code unless required for correctness.

Before introducing a new pattern, abstraction, dependency, or directory, search the project for an existing equivalent.

Prefer simple, explicit implementations over speculative abstractions.

Preserve existing public behavior unless the task explicitly requires changing it.

---

## Sources of truth

Read every document relevant to the task.

- Ruby code → `docs/ruby.md`
- Controllers, models, services, jobs, and business logic → `docs/architecture.md`
- PostgreSQL, migrations, indexes, constraints, queries, transactions, locking, and data migrations → `docs/database.md`
- ERB, HTML, Turbo, Stimulus, JavaScript, forms, and browser behavior → `docs/frontend.md`
- Tailwind, CSS, themes, colors, components, and visual UI → `docs/tailwind.md`
- Third-party APIs, providers, webhooks, and external services → `docs/integrations.md`
- API endpoints, schemas, responses, errors, versioning, and OpenAPI/Swagger → `docs/openapi.md`
- Rails credentials, Solid Queue, recurring jobs, cron, and runtime configuration → `docs/operations.md`
- Logging, error reporting, metrics, tracing, and observability providers → `docs/observability.md`
- Tests and test strategy → `docs/testing.md`
- Authentication, authorization, secrets, user input, uploads, and sensitive data → `docs/security.md`

A task may require more than one document.

Examples:

- UI behavior + styling → `docs/frontend.md` + `docs/tailwind.md`
- External integration → `docs/integrations.md` + `docs/security.md`
- Public API endpoint → `docs/openapi.md` + relevant architecture/database/security/testing docs
- Database-backed workflow → `docs/architecture.md` + `docs/database.md`

`.rubocop.yml` is the source of truth for mechanically enforceable Ruby formatting and style.

Do not introduce conventions that conflict with the relevant source-of-truth documents.

---

## Dependencies

Before adding a dependency:

1. Check whether Rails already provides the functionality.
2. Check whether an existing dependency already provides it.
3. Prefer a small internal implementation when appropriate.
4. Add a dependency only when it meaningfully reduces complexity or risk.

Do not upgrade unrelated dependencies.

---

## Security

Never commit:

- Secrets.
- Credentials.
- API keys.
- Tokens.
- Passwords.
- Production data.

Treat user-controlled input as untrusted.

Do not bypass security protections for convenience.

---

## Validation

Run the narrowest relevant tests and checks while working.

Before completion, run the checks required by the relevant source-of-truth documents.

Do not fix unrelated existing failures unless required for the task.
