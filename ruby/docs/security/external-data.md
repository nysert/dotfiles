# External Data

Detailed guidance referenced by `docs/security.md`. Read this file only when this topic is relevant to the task.

## External APIs

Keep credentials centralized.

Do not log sensitive tokens or secret values.

Validate and normalize third-party responses before trusting them.

Use appropriate:

- Timeouts.
- Error handling.
- Retry behavior.
- Idempotency where necessary.

Do not expose provider-specific secrets to browser-side code unless they are explicitly designed to be public.

---
## File uploads

Validate uploaded files using the application's existing upload mechanism.

Consider:

- File size.
- MIME/content type.
- Filename handling.
- Storage permissions.
- Malware or dangerous content where relevant.
- Public versus private accessibility.

Do not trust filename extensions alone.

---
## Logging and errors

Do not expose sensitive information in logs or error responses.

Avoid logging:

- Passwords.
- Authentication tokens.
- Secret keys.
- Full payment data.
- Sensitive personal information unless explicitly required and properly protected.

Use Rails parameter filtering and project logging conventions.

---
