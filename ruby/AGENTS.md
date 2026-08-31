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

### Ruby

When creating or modifying Ruby code, read:

`docs/ruby.md`

`.rubocop.yml` remains the source of truth for mechanically enforceable Ruby formatting and style.

### Application architecture

When modifying controllers, models, services, background jobs, or business logic, read:

`docs/architecture.md`

### Testing

When adding or changing application behavior, read:

`docs/testing.md`

### Security

When working with authentication, authorization, user input, secrets, external APIs, uploads, or other security-sensitive functionality, read:

`docs/security.md`

### UI / Tailwind

When creating or modifying HTML, ERB, ViewComponents, CSS, Tailwind classes, forms, navigation, or any other user-facing UI, read:

`docs/tailwind.md`

`docs/tailwind.md` is the source of truth for:

- Tailwind conventions.
- Light/dark theming.
- Semantic colors.
- Buttons and interaction states.
- Component reuse.
- Accessibility.
- UI consistency.

Do not introduce conventions that conflict with these files.

---

## Architecture defaults

Prefer:

- Thin controllers.
- Thin models.
- Business workflows in `app/services`.
- Background jobs for work that does not need to complete in the request cycle.
- Standard Rails functionality before custom abstractions.
- Existing project abstractions before new abstractions.

Do not introduce parallel architectural concepts such as:

```text
app/interactors/
app/operations/
app/commands/
app/use_cases/
```

unless the project already intentionally uses them for a separate purpose.

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

---

## Validation

Run the most relevant tests and checks for the files changed.

For Ruby changes, normally run:

```sh
bin/rubocop
bin/rails test
```

Run relevant system tests when changing user-facing behavior:

```sh
bin/rails test:system
```

Do not fix unrelated existing failures unless required for the requested task.
