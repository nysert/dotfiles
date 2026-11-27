# Application Services

Use this guide when creating, changing, or decomposing an application service.

## Name services by domain and action

Put non-trivial application actions in `src/services/<domain>/<action>.rs` within the application crate. Use plural domain names where natural, such as `users`, `payments`, `jobs`, and `concepts`. Capability names such as `ai`, `storage`, and `messaging` can stay singular.

Use specific action verbs. Examples include `users/create.rs`, `payments/refund.rs`, `jobs/normalize.rs`, `concepts/compile.rs`, `messaging/send_message.rs`, and `ai/generate.rs`. Avoid generic names such as `user_service.rs`, `payment_manager.rs`, `job_processor.rs`, and `subscription_handler.rs`. Omit redundant `Service` suffixes on types.

Give each independent action its own module. For example, split a `users.rs` that implements account creation, authentication, and password reset into `users/create.rs`, `users/authenticate.rs`, and `users/reset_password.rs`. Keep supporting functions together when they serve the same action. A trivial helper can stay in its owning file.

Create a service when an operation coordinates business rules, authorization, multiple writes, a transaction, external calls, notifications, or other meaningful behavior. A primary-key lookup can use the ORM or query directly.

## Expose the action contract

Prefer one caller-facing function per action with explicit inputs, dependencies, and results. Use a struct when state or dependency ownership warrants one. Use a trait when polymorphism, substitution, or a genuine abstraction boundary warrants it. Use idiomatic Rust functions in place of a Ruby-style constructor and `call` pair.

For example, `users/create.rs` can define the following contract. The database, model, error, and persistence imports represent application-specific dependencies.

```rust
use crate::{database::Database, errors::AppError, models::User};

pub(crate) struct CreateInput {
    pub(crate) name: String,
    pub(crate) email: String,
}

pub(crate) async fn create(db: &Database, input: CreateInput) -> Result<User, AppError> {
    let user = User::new(input.name, input.email)?;
    db.insert_user(user).await
}
```

Keep domain-level `mod.rs` files focused on module declarations, intentional re-exports, and small shared contracts where appropriate. For example, `users/mod.rs` can expose the action and its input:

```rust
mod create;

pub(crate) use create::{create, CreateInput};
```

Callers import `crate::services::users` and call `users::create(&db, input).await?`. Default implementation details to private. Use `pub(super)`, `pub(crate)`, or another restricted visibility only as far as the caller contract requires.

Keep action-specific inputs, outputs, errors, and helpers with their action. Extract shared behavior and types only when multiple consumers genuinely need them. Name shared modules for their responsibility and avoid catch-all files such as `utils.rs`, `helpers.rs`, `common.rs`, `manager.rs`, or `processor.rs`.

## Decompose complex actions by responsibility

When an action develops distinct internal responsibilities, promote its file to a directory:

```text
services/users/register/
├── mod.rs
├── input.rs
├── validate.rs
├── account.rs
├── organization.rs
└── notification.rs
```

Keep orchestration in the action's `mod.rs` and expose the same `users::register(&db, input).await?` interface through the domain re-export. Keep implementation submodules private and limit their functions to the visibility needed by the action.

This example assumes application-specific database, model, and error types. The notification step writes to an outbox in the same transaction. A separate worker delivers it after commit.

```rust
mod account;
mod input;
mod notification;
mod organization;
mod validate;

use crate::{database::Database, errors::AppError, models::User};

pub(crate) use input::RegisterInput;

pub(crate) async fn register(db: &Database, input: RegisterInput) -> Result<User, AppError> {
    validate::execute(&input)?;

    let mut tx = db.begin().await?;
    let user = account::create(&mut tx, &input).await?;
    organization::create(&mut tx, &user).await?;
    notification::enqueue(&mut tx, &user).await?;
    tx.commit().await?;

    Ok(user)
}
```

The transaction is assumed to roll back when an uncommitted transaction is dropped. Read [Workflows and Boundaries](workflows.md) for transaction ownership and side-effect ordering, and [Complexity Review](../rust/complexity.md) for when to split an implementation.

## Framework and persistence examples

These illustrative layouts show selected paths under `src/`. Include directories as needed and use the framework's actual conventions.

| Application | Entry points and persistence | Service modules |
| --- | --- | --- |
| Loco.rs + SeaORM | `controllers/`, `models/_entities/`, `models/users.rs`, `workers/` | `services/users/{mod,create,update}.rs` |
| Standalone Axum + SeaORM | `handlers/`, `entities/` | `services/users/{mod,create}.rs` |
| Axum + Diesel | `handlers/`, `schema.rs`, `models/` | `services/users/{mod,create}.rs` |
| Axum + SQLx | `handlers/`, `models/`, optional `repositories/` | `services/users/{mod,create}.rs` |

A reusable library can use `src/lib.rs`, `src/parser/{mod,tokenize,parse}.rs`, and `src/validation/{mod,rules}.rs`. It can omit `services/` and follows the same cohesion and complexity rules.
