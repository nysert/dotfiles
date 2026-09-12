# AGENTS.md

## Project

This is a Ruby on Rails application.

Follow existing Rails conventions and project patterns unless project instructions explicitly define otherwise.

Keep changes focused on the requested task. Do not modify unrelated code unless required for correctness.

Before introducing a new pattern, abstraction, dependency, or directory, search the project for an existing equivalent.

Prefer simple, explicit implementations over speculative abstractions.

Preserve existing public behavior unless the task explicitly requires changing it.

---

## Sources of truth

Project guidance uses progressive disclosure:

1. Read every applicable **top-level** `docs/*.md` file before making changes.
2. From those files, read every **nested topical** document that governs the specific behavior being changed.
3. Read **example** files only when a concrete example is useful for the current implementation; examples are not default context.

Do not recursively load an entire documentation tree merely because files are linked.

### Top-level routing

A top-level document is mandatory when the task creates, changes, removes, reviews, or debugs behavior in its scope:

- Any Ruby code → `docs/ruby.md`
- Controllers, models, services, jobs, or business/application workflows → `docs/architecture.md`
- Persistence, migrations, PostgreSQL, indexes, constraints, queries, transactions, locking, or data migrations → `docs/database.md`
- ERB, HTML, Turbo, Stimulus, JavaScript, forms, DOM/browser behavior, or interactive UI → `docs/frontend.md`
- Tailwind, CSS, themes, colors, component appearance, layout, or other visual UI → `docs/tailwind.md`
- Third-party APIs, providers, SDKs, webhooks, or external services → `docs/integrations.md`
- Public API endpoints/contracts, schemas, responses, errors, versioning, pagination, or OpenAPI/Swagger → `docs/openapi.md`
- Rails credentials, runtime configuration, Solid Queue, background execution, recurring jobs, cron, or deployment-sensitive behavior → `docs/operations.md`
- Logging, error reporting, metrics, tracing, or observability providers → `docs/observability.md`
- Any application behavior change that should be verified by tests → `docs/testing.md`
- Authentication, authorization, secrets, user-controlled input, uploads, external data, or sensitive data → `docs/security.md`

A task may require several top-level documents. Read all that apply; do not choose only the most obvious one.

Common combinations:

- UI behavior + styling → `docs/frontend.md` + `docs/tailwind.md`
- Ruby workflow with persistence → `docs/ruby.md` + `docs/architecture.md` + `docs/database.md` + `docs/testing.md`
- External integration → `docs/integrations.md` + `docs/security.md` + `docs/testing.md`; also read operations/observability when the change affects retries, jobs, configuration, logging, metrics, or tracing
- Public API endpoint → `docs/openapi.md` + `docs/ruby.md` + relevant architecture/database/security/testing docs
- Background or recurring workflow → `docs/architecture.md` + `docs/operations.md` + `docs/testing.md`; add integrations/database/security when those concerns are involved

### Nested topical routing

Top-level documents contain a `Read when relevant` section that maps narrower concerns to nested files such as `docs/<area>/<topic>.md`.

A linked nested topical file is **mandatory** when any of the following is true:

- The requested change directly concerns the topic named by that link.
- Files or behavior being modified are explicitly covered by that topic.
- The implementation requires making a design choice governed by that topic.
- The task changes an existing pattern whose rules are defined in that topic.
- The topic contains completion or validation requirements applicable to the change.

If several nested topics apply, read each applicable topic file. If none apply beyond the top-level rules, stop at the top-level document.

Do not read unrelated sibling topic files for completeness.

Examples:

- Creating or changing a Stimulus controller → `docs/frontend.md` + `docs/frontend/stimulus.md`; add `docs/tailwind.md` only if visual styling changes.
- Adding an index → `docs/database.md` + the nested database topic covering indexes/queries; do not load data-migration guidance unless data movement is also required.
- Changing API validation errors → `docs/openapi.md` + the nested responses/errors topic; read schema/type guidance only if the schema contract also changes.
- Adding a provider webhook processed in a background job → integration webhook/reliability topics + applicable operations/job, security, architecture, and testing guidance.

### Example files

Files named `examples.md` contain concrete reference implementations and are intentionally separated from mandatory rules.

Do **not** read an example file by default.

Read the relevant `examples.md` only when at least one of these is true:

- The task asks for an example or asks to match an established documented example.
- The applicable rule/topic is clear, but concrete syntax or structure is needed to implement it correctly.
- Existing project code does not provide a sufficiently close canonical implementation.
- You are creating a new instance of a documented pattern and need to confirm the expected shape.

When an example file is needed, read only the example file for the applicable area; do not load example files from unrelated areas.

Examples illustrate rules; they do not override them. If an example conflicts with a top-level or nested topical rule, follow the rule. Prefer an existing canonical project implementation over copying a generic example when both satisfy the documented rules.

### Authority within project guidance

Within these project files:

- `AGENTS.md` defines routing and repository-wide instructions.
- Applicable top-level and nested topical documents define normative domain rules.
- `examples.md` files are supporting references, not independent policy.
- `.rubocop.yml` is the source of truth for mechanically enforceable Ruby formatting and style.

Do not introduce conventions that conflict with the applicable source-of-truth documents.

---

## Dependencies

Before adding a dependency:

1. Check whether Rails already provides the functionality.
2. Check whether an existing dependency already provides it.
3. Prefer a small internal implementation when appropriate.
4. Add a dependency only when it meaningfully reduces complexity or risk.

Do not upgrade unrelated dependencies.

---

## Security

Never commit secrets, credentials, API keys, tokens, passwords, private keys, or production data.

Treat user-controlled input as untrusted.

Do not bypass security protections for convenience.

---

## Validation

Run the narrowest relevant tests and checks while working.

Before completion, run the checks required by every applicable top-level and nested source-of-truth document.

Do not fix unrelated existing failures unless required for the task.
