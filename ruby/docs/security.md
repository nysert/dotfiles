# Security Guidelines

Use this file when working with authentication, authorization, user input, secrets, external APIs, uploads, user data, or other security-sensitive functionality.

Security protections must not be bypassed merely to simplify implementation.

## Core rules

- Never commit secrets, credentials, API keys, tokens, passwords, private keys, or production data.
- Treat all user-controlled input as untrusted.
- Use the application's existing authentication system and enforce authorization server-side.
- Keep Rails CSRF and escaping protections enabled unless the existing API/security architecture explicitly requires another approach.
- Never interpolate untrusted values into raw SQL.
- Do not use `html_safe` as a convenience shortcut.
- Do not expose provider secrets to browser code unless explicitly designed to be public.
- Do not log sensitive credentials, tokens, payment data, or unnecessary personal information.

## Read when relevant

- Secrets, input, authentication, authorization, CSRF, database access, XSS → `docs/security/application-security.md`
- External APIs, file uploads, logging/error exposure → `docs/security/external-data.md`
- Security review checklist → `docs/security/review.md`
