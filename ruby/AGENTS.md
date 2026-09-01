# AGENTS.md

## Project

This is a Ruby on Rails application.

Follow existing Rails conventions and project patterns unless project instructions explicitly define otherwise.

Keep changes focused on the requested task.

Do not modify unrelated code unless required for correctness.

Before introducing a new pattern or abstraction, search the project for an existing equivalent.

---

## Sources of truth

Use these project documents when working in the corresponding area.

A task may require reading more than one document.

### Ruby

When creating or modifying Ruby code, read:

`docs/ruby.md`

`.rubocop.yml` remains the source of truth for mechanically enforceable Ruby formatting and style.

---

### Application architecture

When modifying controllers, models, services, background jobs, or business logic, read:

`docs/architecture.md`

This document defines the application's architectural conventions, including:

- Thin controllers.
- Thin models.
- Service organization.
- Service naming.
- Background job responsibilities.
- Rails application structure.

---

### Database / PostgreSQL

When creating or modifying:

- Migrations.
- PostgreSQL schema.
- Primary keys.
- Foreign keys.
- Indexes.
- Constraints.
- Active Record persistence.
- Queries.
- Transactions.
- Locking.
- Data migrations.
- Database performance.

read:

`docs/database.md`

This document is the source of truth for PostgreSQL-specific conventions, including the use of UUIDv7 for new application-owned primary keys.

---

### Frontend

When creating or modifying:

- ERB.
- HTML structure.
- Turbo.
- Turbo Frames.
- Turbo Streams.
- Stimulus.
- JavaScript.
- Forms.
- DOM behavior.
- Browser-side interactions.

read:

`docs/frontend.md`

For changes that also affect visual styling, themes, Tailwind classes, colors, or UI components, also read:

`docs/tailwind.md`

---

### UI / Tailwind

When creating or modifying:

- CSS.
- Tailwind classes.
- Visual components.
- Buttons.
- Inputs.
- Navigation.
- Cards.
- Dialogs.
- Responsive layouts.
- Light/dark themes.
- Colors.
- User-facing visual design.

read:

`docs/tailwind.md`

`docs/tailwind.md` is the source of truth for:

- Tailwind conventions.
- Light/dark theming.
- Semantic colors.
- Buttons and interaction states.
- Component reuse.
- Accessibility.
- UI consistency.

Do not introduce UI conventions that conflict with this file.

---

### External integrations

When creating or modifying integrations with third-party services or APIs, including:

- Payments.
- Email.
- SMS.
- WhatsApp.
- AI/LLM providers.
- Storage providers.
- Search providers.
- Analytics providers.
- Webhooks.
- External APIs.

read:

`docs/integrations.md`

Provider-specific implementations should remain isolated behind application-owned interfaces when provider portability is useful.

Integration code should follow the project's convention of living under:

`app/services/`

Do not introduce new top-level application directories such as:

```text
app/clients/
app/adapters/
app/gateways/
app/integrations/
```

unless project instructions explicitly change this convention.

For integrations involving secrets, authentication, external input, or sensitive data, also read:

`docs/security.md`

---

### OpenAPI / API contracts

When creating or modifying:

- API endpoints.
- API request schemas.
- API response schemas.
- API error formats.
- API authentication documentation.
- API versioning.
- Pagination.
- Filtering.
- Sorting.
- OpenAPI definitions.
- Swagger/OpenAPI generation.

read:

`docs/openapi.md`

The Rails implementation and OpenAPI contract must remain synchronized.

Do not allow the OpenAPI definition to become one giant file.

Follow the project's modular OpenAPI structure for versioned resources, actions, shared schemas, and shared responses.

For API implementation changes, also read the relevant:

- `docs/architecture.md`
- `docs/database.md`
- `docs/security.md`
- `docs/testing.md`

as applicable.

---

### Operations

When creating or modifying:

- Rails credentials.
- Runtime configuration.
- Background job configuration.
- Solid Queue.
- Scheduled jobs.
- Recurring jobs.
- Cron.
- Queue configuration.
- Deployment-sensitive application behavior.
- Operational processes.

read:

`docs/operations.md`

Prefer:

- Rails credentials for secrets.
- Active Job for application jobs.
- Solid Queue for background processing.
- Solid Queue recurring tasks for application-owned schedules.

Do not introduce additional operational infrastructure when the existing Rails stack reasonably satisfies the requirement.

---

### Observability

When creating or modifying:

- Logging.
- Error reporting.
- Metrics.
- Tracing.
- Operational events.
- Observability providers.
- Error-monitoring providers.

read:

`docs/observability.md`

Application-facing observability code should remain provider-independent when practical.

Provider-specific observability implementations should live under:

`app/services/`

Do not introduce new top-level application directories such as:

```text
app/observability/
app/telemetry/
app/instrumentation/
```

unless project instructions explicitly change this convention.

For sensitive logging or error-reporting behavior, also read:

`docs/security.md`

---

### Testing

When adding or changing application behavior, read:

`docs/testing.md`

Add or update tests for behavior changed by the task.

Test public behavior rather than private implementation details.

---

### Security

When working with:

- Authentication.
- Authorization.
- User-controlled input.
- Secrets.
- Credentials.
- External APIs.
- Webhooks.
- File uploads.
- Sensitive data.
- Logging of user/provider data.
- API security.

read:

`docs/security.md`

Security rules apply in addition to any more specific document such as:

- `docs/integrations.md`
- `docs/openapi.md`
- `docs/operations.md`
- `docs/observability.md`

---

## Architecture defaults

Prefer:

- Thin controllers.
- Thin models.
- Business workflows in `app/services`.
- Background jobs for work that does not need to complete in the request cycle.
- Standard Rails functionality before custom abstractions.
- Existing project abstractions before new abstractions.

Keep application-side service abstractions under:

```text
app/services/
```

This includes appropriate:

- Business workflows.
- External provider wrappers.
- Provider implementations.
- API response/error serialization.
- Observability abstractions.

Do not introduce parallel architectural concepts or new top-level application directories such as:

```text
app/interactors/
app/operations/
app/commands/
app/use_cases/
app/clients/
app/adapters/
app/gateways/
app/integrations/
app/observability/
app/telemetry/
```

unless the project already intentionally uses them for a separate purpose or project instructions explicitly require them.

---

## Dependencies

Before adding a dependency:

1. Check whether Rails already provides the functionality.
2. Check whether an existing dependency provides it.
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

Do not bypass Rails security protections for convenience.

Use Rails credentials and the project's existing secret-management conventions.

See `docs/security.md` for detailed security rules.

---

## Changes

Keep implementations as simple as reasonably possible.

Prefer:

- Existing patterns.
- Small focused classes.
- Explicit code.
- Clear naming.
- Simple control flow.

Avoid speculative abstractions and infrastructure for hypothetical future requirements.

Preserve existing public behavior unless the task explicitly requires changing it.

When modifying an existing external API contract, provider interface, database schema, or scheduled workflow, consider backward compatibility before making breaking changes.

---

## Validation

Run the most relevant tests and checks for the files changed.

During implementation, prefer the narrowest relevant tests for fast feedback.

For Ruby changes, normally run:

```sh
bin/rubocop
bin/rails test
```

Run relevant system tests when changing user-facing behavior:

```sh
bin/rails test:system
```

When changing OpenAPI definitions, run the project's OpenAPI generation and validation commands.

When changing database behavior, run relevant migration/database tests and inspect query behavior when appropriate.

Do not fix unrelated existing failures unless required for the requested task.
