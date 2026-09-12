# Review

Detailed guidance referenced by `docs/security.md`. Read this file only when this topic is relevant to the task.

## Security review checklist

Before completing security-sensitive work, verify:

- [ ] No secrets were added to source control.
- [ ] User input is treated as untrusted.
- [ ] Authentication uses the existing system.
- [ ] Authorization is enforced server-side.
- [ ] CSRF protection remains appropriate.
- [ ] SQL queries do not interpolate untrusted input.
- [ ] HTML output remains escaped or safely sanitized.
- [ ] External API credentials remain server-side.
- [ ] Sensitive data is not exposed in logs or errors.
- [ ] File uploads are validated where applicable.
- [ ] Security protections were not weakened for convenience.
