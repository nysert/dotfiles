# Security

Read for authentication, authorization, secrets, untrusted input, unsafe code, FFI, or sensitive data.

- Never commit secrets, private keys, tokens, credentials, or production data.
- Enforce authentication and authorization at trusted server boundaries.
- Validate sizes, ranges, encodings, paths, and payloads before expensive processing.
- Parameterize SQL; do not interpolate untrusted shell/SQL commands.
- Prevent secret disclosure through `Debug`, panics, logs, and traces.
- Bound computation and memory usage for external inputs.
- Use established cryptographic primitives, not custom crypto.
- Avoid `unsafe` unless necessary and explicitly justified.
- Follow the repository's established dependency-audit workflow.

## Read when relevant

- Unsafe Rust, memory invariants, raw pointers, FFI → `docs/agents/security/unsafe-ffi.md`

Test invalid inputs, permissions, and security boundaries when relevant.
