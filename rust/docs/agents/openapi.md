# HTTP API Contracts

Read for public endpoints, request/response types, status codes, and OpenAPI.

- Follow the project's API versioning policy and existing schema generator.
- Validate inputs at transport boundaries; represent protocol contracts with explicit types.
- Consider Serde field naming, optional vs null, unknown fields, and serialization compatibility.
- Keep documented schemas synchronized with actual request and response behavior.
- Use consistent error envelopes, pagination, identifiers, and idempotency rules.
- Keep internal implementation details and sensitive error context out of external responses.
- Test successful, invalid, unauthorized, and relevant compatibility cases.
- Do not add a parallel OpenAPI generator without a concrete requirement.
