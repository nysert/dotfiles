# Security Guidelines

Use this file when working with authentication, authorization, user input, secrets, external APIs, uploads, filesystem access, command execution, or sensitive data.

Security protections must not be bypassed merely to simplify implementation.

## Core rules

- Never commit secrets, credentials, API keys, tokens, passwords, private keys, or production data.
- Treat user-controlled and external input as untrusted.
- Validate and normalize input at trust boundaries.
- Enforce authentication server-side.
- Enforce authorization server-side.
- Use parameterized SQL or safe library query APIs.
- Never concatenate untrusted values into SQL.
- Do not pass untrusted values to a shell.
- Prefer direct process execution with argument arrays when a child process is required.
- Protect filesystem operations against path traversal.
- Do not trust user-supplied paths.
- Treat user-controlled URLs as SSRF-sensitive when the server performs outbound requests.
- Do not use `eval`, `new Function`, or dynamic code execution with untrusted content.
- Keep secrets and server-only dependencies out of browser bundles.
- Preserve framework CSRF, origin, cookie, and session protections when relevant.
- Validate upload type and size.
- Avoid logging tokens, credentials, sensitive payloads, or unnecessary personal data.
- Do not perform unrelated bulk dependency upgrades during feature work.

## Security review

For security-sensitive changes, explicitly verify authentication, authorization, validation, error exposure, logging, filesystem/network boundaries, and relevant abuse paths in tests.
