# AGENTS.md

## Project

This is a Rust application or library.

Follow the repository's Cargo workspace, crate boundaries, Rust edition, toolchain, and existing conventions unless project instructions say otherwise.

Keep changes focused. Preserve existing public behavior unless a change is requested. Before introducing a dependency, crate, abstraction, or directory, look for an existing equivalent. Prefer simple, idiomatic Rust over speculative abstractions.

Do not switch async runtimes, web frameworks, persistence libraries, or error libraries incidentally. Do not upgrade unrelated dependencies or change the edition/toolchain without a specific need.

---

## Sources of truth

Use progressive disclosure:

1. Read all applicable **top-level** `docs/agents/*.md` documents before changing behavior.
2. Read **nested topical** files linked by those documents only when the specific topic applies.
3. Consult examples and extra supporting files only when useful; do not recursively ingest the whole tree.

### Top-level routing

- Any Rust code, type, trait, ownership, error, or async change → `docs/agents/rust.md`
- HTTP/CLI handlers, services, domain flows, jobs, or crate architecture → `docs/agents/architecture.md`
- Database, SQL, migrations, queries, transactions, locking → `docs/agents/database.md`
- Browser/WASM behavior, forms, interactive UI, client/server boundary → `docs/agents/frontend.md`
- Provider APIs, SDKs, webhooks, external calls → `docs/agents/integrations.md`
- Public HTTP contracts, schemas, errors, pagination, OpenAPI → `docs/agents/openapi.md`
- Environment config, runtimes, workers, queues, deployments → `docs/agents/operations.md`
- Logging, tracing, metrics, diagnostics → `docs/agents/observability.md`
- Behavior changes needing tests → `docs/agents/testing.md`
- Authentication, authorization, secrets, unsafe/FFI, uploads, untrusted input → `docs/agents/security.md`

Read **all** applicable documents. For example, a persisted background workflow requires Rust, architecture, database, operations, and testing; an external HTTP endpoint may also need integrations, OpenAPI, and security.

### Nested routing

Top-level documents identify optional narrower guidance under `docs/agents/<area>/`. Read each linked file whose topic, design choices, or completion requirements apply. Do not read unrelated siblings.

### Authority

- `AGENTS.md`: guidance routing and general rules.
- Applicable top-level and topical docs: domain-specific conventions.
- Project `Cargo.toml`, committed `Cargo.lock`, `rust-toolchain.toml`, source, and CI: actual dependencies, edition, toolchain, and required checks.
- Project `.rustfmt.toml`/`rustfmt.toml` and Clippy settings: mechanically enforceable style.

When adopting this preset in another project, follow that project's actual configuration rather than imposing conflicting assumptions.

---

## Dependencies

Before adding a crate, check the standard library, framework, and existing workspace dependencies. Prefer a small local implementation when simpler. Add only dependencies that reduce real complexity or risk; respect features, lockfile policy, and supported targets.

---

## Security

Never commit secrets, credentials, tokens, private keys, or production data. Treat external input as untrusted; bound work and use parameterized SQL. Avoid unsafe Rust unless necessary, document invariants, and test its boundary. Keep secrets out of logs and errors.

---

## Grafana Cloud observability

For slow HTTP requests, SQL, async tasks, and cross-service errors, prefer **Grafana Cloud Explore → Tempo** (trace waterfalls) and **Explore → Loki** (logs) when connected. Read `docs/agents/observability.md` and the project's runbook. Rust `tracing` spans do **not** automatically ship stdout logs or export OpenTelemetry spans without configuration.

Default to plain Grafana Cloud Free signals; **do not enable host-billed Application Observability or Database Observability** without explicit approval. Never claim live Grafana access without actual evidence.

---

## Validation

Start with focused checks. For a typical Cargo workspace without a stronger existing contract:

```sh
cargo fmt --all -- --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
```

Run the supported toolchain, features, targets, and integration tests defined by the project. Use `--all-features` only when the combination is supported. `cargo fmt --all` mutates files; run non-mutating checks before completion. Report tests that could not run, and do not modify unrelated code to silence pre-existing failures.
