# Implementation

Detailed guidance referenced by `docs/node.md`.

Read this file when implementation details, TypeScript, asynchronous behavior, or error handling are relevant.

## Formatting and linting

Let the project's local formatter and linter decide mechanically enforceable style.

Do not hand-format code in ways that intentionally conflict with ESLint, Prettier, or Biome configuration.

Do not depend on globally installed formatter or linter versions.

## TypeScript

When the project uses TypeScript:

- Prefer precise types at module boundaries.
- Prefer inference for obvious local values.
- Avoid `any`.
- Use `unknown` at untrusted boundaries and narrow it.
- Do not use type assertions merely to hide unresolved type errors.
- Prefer discriminated unions for state with meaningful variants.
- Keep runtime validation separate from static typing.

TypeScript types do not validate network, file, environment, database JSON, external API, or user input.

## Async code

- Prefer `async`/`await` over deeply nested promise chains.
- Await or return promises deliberately.
- Use `Promise.all` only when operations are independent and safe to run concurrently.
- Avoid unbounded concurrency when processing large collections or making external requests.
- Propagate cancellation and timeouts when the surrounding stack supports them.
- Do not convert recoverable asynchronous errors into unhandled promise rejections.

## Errors

- Throw `Error` objects rather than strings.
- Preserve the underlying cause when wrapping errors where supported.
- Add context at meaningful boundaries rather than wrapping the same error repeatedly.
- Convert internal exceptions into stable public/API errors at the transport boundary.
- Do not expose stack traces, SQL errors, internal filesystem paths, provider credentials, or sensitive provider payloads.
- Do not log and rethrow the same error at multiple layers unless each layer adds distinct operational value.

## Implementation guidance

Before creating a new abstraction:

1. Search for an existing equivalent.
2. Prefer standard Node.js or framework patterns.
3. Keep the public API small.
4. Prefer composition over inheritance.
5. Avoid generic helper or manager layers that only rename another API.
6. Avoid speculative abstractions.

If behavior represents application workflow or orchestration rather than a small intrinsic operation, follow `docs/architecture.md`.
