# Application and Library Architecture

Read for module organization, entry points, jobs, application workflows, or boundaries.

## Applications

- Put every non-trivial application workflow in `src/services/<domain>/<action>.rs` in the appropriate application crate. Each service module owns one cohesive business action. Applications without application workflows can omit `services/`.
- Keep controllers, workers, MCP tools, CLI handlers, and scheduled tasks thin. Validate boundary inputs, call services, and translate results and errors at the entry point.
- Give services framework-independent interfaces with explicit dependencies. Choose sync or async based on the actual I/O and concurrency needs.
- Keep intrinsic behavior and domain invariants close to the types that own them. Use explicit transaction boundaries for atomic persistence and plan external side effects separately.
- Keep application-side integrations inside their owning service domains. Add repositories only where persistence or query complexity warrants them.

| Location | Responsibility |
| --- | --- |
| `services/` | Application workflows and external integrations |
| `models/` | Domain models and intrinsic behavior |
| `entities/` | ORM entities, where appropriate |
| `repositories/` | Optional persistence and query abstraction |
| `controllers/` or `handlers/` | HTTP or framework entry points |
| `workers/` | Background execution |
| `middleware/` | Request-level infrastructure |
| `config/` | Runtime configuration |
| `mcp/` | MCP transport and tool entry points |

Create directories as their responsibilities arise. Preserve framework-required files, routing, generated modules, and existing ORM conventions. The same service layout applies across web and RPC frameworks, ORM and database libraries, MCP, CLI applications, and background workers.

Reserve application workflows and their provider implementations for the service layer. Do not introduce equivalent top-level layers under `src/commands/`, `src/use_cases/`, `src/interactors/`, `src/operations/`, `src/integrations/`, `src/clients/`, `src/adapters/`, or `src/gateways/`. Framework-required directories with distinct responsibilities, such as CLI command definitions or deployment operations, are exempt. Migrate legacy directories only when the task calls for it.

## Libraries

Reusable libraries, SDKs, parsers, algorithms, and infrastructure crates may organize by domain or capability without a service directory. Apply the same rules for cohesion, visibility, and complexity to their production modules.

## Read when relevant

- Application service paths, naming, visibility, and decomposition → `docs/agents/architecture/services.md`
- Workflow composition, dependencies, transactions, retries, and side effects → `docs/agents/architecture/workflows.md`
- Module and function size, responsibility review, and decomposition → `docs/agents/rust/complexity.md`
- External integration boundaries and reliability → `docs/agents/integrations.md`
