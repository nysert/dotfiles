# Application Security

Detailed guidance referenced by `docs/security.md`. Read this file only when this topic is relevant to the task.

## Secrets

Never commit:

- Secrets.
- Credentials.
- API keys.
- Tokens.
- Passwords.
- Private keys.
- Production data.

Use the project's existing secret-management mechanism, such as:

- Rails credentials.
- Environment variables.
- Secret-management services.

Never hard-code secrets into:

- Ruby files.
- ERB templates.
- JavaScript.
- CSS.
- Test fixtures intended for committed source.
- Documentation examples containing real credentials.

---
## User input

Treat all user-controlled input as untrusted.

Use Rails protections and existing project patterns for:

- Strong parameters.
- Validation.
- HTML escaping.
- SQL injection prevention.
- File uploads.
- URL handling.
- Redirect handling.

Do not interpolate untrusted values into raw SQL.

Avoid marking user-generated content as HTML-safe unless it has been safely sanitized and the behavior is explicitly required.

---
## Authentication

Use the application's existing authentication system.

Do not build parallel authentication mechanisms without a clear requirement.

Do not weaken authentication behavior to simplify tests or implementation.

Be careful with:

- Session handling.
- Password reset flows.
- Remember-me behavior.
- Multi-factor authentication.
- Account lockout.
- Impersonation.

---
## Authorization

Authentication and authorization are separate concerns.

Every action that accesses or mutates protected resources must enforce the appropriate authorization boundary.

Do not rely solely on:

- Hidden UI elements.
- Client-side checks.
- Untrusted record IDs.
- Route obscurity.

Authorization must be enforced server-side.

---
## CSRF

Keep Rails CSRF protections enabled.

Do not disable forgery protection globally to make an integration easier.

For API endpoints, follow the application's existing API authentication and CSRF strategy.

---
## Database access

Prefer Active Record query APIs.

Avoid raw SQL unless it materially improves the implementation and can be written safely.

Never concatenate user input into SQL strings.

Use database constraints where appropriate to protect important invariants.

---
## HTML and XSS

Rails escaping should remain enabled by default.

Treat:

- User-entered HTML.
- Markdown rendering.
- Rich text.
- URL parameters.
- Third-party API content.

as potentially unsafe.

Sanitize content before rendering when HTML is intentionally supported.

Do not use `html_safe` as a convenience shortcut.

---
