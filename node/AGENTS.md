# AGENTS.md

## Project

This is a Node.js application.

Follow the project's existing framework, package manager, module system, TypeScript/JavaScript choices, and repository patterns unless project instructions explicitly define otherwise.

Keep changes focused on the requested task. Do not modify unrelated code unless required for correctness.

Before introducing a new pattern, abstraction, dependency, or directory, search the project for an existing equivalent.

Prefer simple, explicit implementations over speculative abstractions.

Preserve existing public behavior unless the task explicitly requires changing it.

Do not migrate JavaScript to TypeScript, CommonJS to ESM, package managers, test runners, ORMs, or frameworks as incidental cleanup.

---

## Sources of truth

Project guidance uses progressive disclosure:

1. Read every applicable **top-level** `docs/*.md` file before making changes.
2. From those files, read every **nested topical** document that governs the specific behavior being changed.
3. Prefer existing project code over generic examples when both satisfy the documented rules.

Do not recursively load an entire documentation tree merely because files are linked.

### Top-level routing

A top-level document is mandatory when the task creates, changes, removes, reviews, or debugs behavior in its scope:

- Any Node.js, JavaScript, or TypeScript code → `docs/node.md`
- HTTP handlers/controllers, services, jobs, or business/application workflows → `docs/architecture.md`
- Persistence, migrations, SQL, indexes, constraints, queries, transactions, locking, or data migrations → `docs/database.md`
- Browser code, client/server boundaries, forms, DOM behavior, or interactive UI → `docs/frontend.md`
- Third-party APIs, providers, SDKs, webhooks, or external services → `docs/integrations.md`
- Public API endpoints/contracts, schemas, responses, errors, versioning, pagination, or OpenAPI → `docs/openapi.md`
- Environment variables, runtime configuration, workers, queues, scheduled work, or deployment-sensitive behavior → `docs/operations.md`
- Logging, error reporting, metrics, tracing, or observability providers → `docs/observability.md`
- Any application behavior change that should be verified by tests → `docs/testing.md`
- Authentication, authorization, secrets, user-controlled input, uploads, external data, or sensitive data → `docs/security.md`

A task may require several top-level documents. Read all that apply.

Common combinations:

- Node workflow with persistence → `docs/node.md` + `docs/architecture.md` + `docs/database.md` + `docs/testing.md`
- External integration → `docs/integrations.md` + `docs/security.md` + `docs/testing.md`
- Public API endpoint → `docs/openapi.md` + `docs/node.md` + relevant architecture/database/security/testing docs
- Background or recurring workflow → `docs/architecture.md` + `docs/operations.md` + `docs/testing.md`
- Browser-facing behavior → `docs/frontend.md` + `docs/security.md` + `docs/testing.md`

### Nested topical routing

Top-level documents contain a `Read when relevant` section when narrower rules exist.

A linked nested topical file is mandatory when the requested change directly concerns the topic or requires a design choice governed by it.

Do not read unrelated sibling topic files for completeness.

### Authority within project guidance

Within these project files:

- `AGENTS.md` defines routing and repository-wide instructions.
- Applicable top-level and nested topical documents define normative domain rules.
- `package.json` and the committed lockfile define dependencies, scripts, and package-manager expectations.
- `tsconfig*.json` defines TypeScript compiler/module semantics when TypeScript is used.
- The project's ESLint, Prettier, or Biome configuration is the source of truth for mechanically enforceable linting and formatting.

Do not introduce conventions that conflict with the applicable source-of-truth files.

---

## Package manager and dependencies

Use the package manager already selected by the repository.

Infer it from the committed lockfile and/or the `packageManager` field in `package.json`.

Do not create a second lockfile or switch package managers as incidental cleanup.

Before adding a dependency:

1. Check whether Node.js or the active framework already provides the functionality.
2. Check whether an existing dependency already provides it.
3. Prefer a small internal implementation when appropriate.
4. Add a dependency only when it meaningfully reduces complexity or risk.
5. Use the project's existing package-manager command and preserve the lockfile.

Do not upgrade unrelated dependencies.

---

## Security

Never commit secrets, credentials, API keys, tokens, passwords, private keys, or production data.

Treat user-controlled and external input as untrusted.

Do not bypass authentication, authorization, validation, escaping, CSRF/origin protections, or transport security for convenience.

---

## Validation

Use the scripts defined in `package.json` rather than invoking globally installed project tooling.

### While working

Run the narrowest relevant tests and checks first.

When the project defines a `fix` script, run the repository's package-manager equivalent of:

```sh
npm run fix
```

The recommended contract is:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "fix": "npm run lint:fix; npm run format"
  }
}
```

`fix` is allowed to modify files.

Its purpose is to apply all available mechanical fixes:

1. Run ESLint auto-fixes.
2. Run Prettier even if ESLint still reports unresolved lint errors.
3. Leave final pass/fail verification to `check`.

After running `fix`, review the resulting diff and do not accept unrelated changes.

### Before completion

If the project defines a `check` script, run the repository's package-manager equivalent of:

```sh
npm run check
```

`check` is the authoritative non-mutating completion gate.

A typical script is:

```json
{
  "scripts": {
    "check": "npm run format:check && npm run lint && npm run typecheck && npm run test"
  }
}
```

Add `npm run build` to `check` when the project has a meaningful build step that should be part of completion verification.

Because `check` uses `&&`, it should stop at the first failed verification and return a non-zero exit code.

Do not treat a successful `fix` command as proof that the change passes validation.

If `check` does not exist, run the applicable verification scripts individually:

```sh
npm run format:check
npm run lint
npm run typecheck
npm run test
npm run build
```

Run only scripts that exist in the repository.

Do not invent missing scripts merely to satisfy these instructions unless the task is specifically establishing project tooling.

Do not fix unrelated existing failures unless required for the task.

Clearly report any required check that could not be run or did not pass.
