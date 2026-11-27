# External Providers

Use this guide when introducing, changing, or decomposing an application-side provider integration.

## Keep providers in their service domains

Place provider-specific code in `src/services/<domain>/providers/<provider>.rs`. For example, a payments domain with two providers can use:

```text
src/services/payments/
├── mod.rs
├── charge.rs
├── refund.rs
├── gateway.rs
├── types.rs
└── providers/
    ├── mod.rs
    ├── stripe.rs
    └── adyen.rs
```

| Module | Responsibility |
| --- | --- |
| `charge.rs` | Application payment workflow |
| `refund.rs` | Application refund workflow |
| `gateway.rs` | Stable provider interface and centralized selection |
| `types.rs` | Shared application-owned contracts |
| `providers/stripe.rs` | Stripe-specific implementation |
| `providers/adyen.rs` | Adyen-specific implementation |

Create supporting modules only when they have a distinct responsibility. A workflow can call a single domain-local provider directly when it needs neither provider selection nor a shared interface.

## Expose application contracts

Controllers, workers, MCP tools, and unrelated workflows call the application action, for example `payments::charge(&gateway, input).await?`. Keep provider-branded calls, SDK types, authentication details, and wire formats within the provider boundary.

Normalize responses into application-owned concepts. This example assumes a shared application-defined `PaymentStatus`:

```rust
pub(crate) struct PaymentReceipt {
    pub(crate) external_id: String,
    pub(crate) status: PaymentStatus,
}
```

Translate SDK and network errors at the boundary into failures meaningful to the application, such as timeout, rate limited, invalid request, or temporarily unavailable. Retain useful context and keep credentials and sensitive payloads out of logs and errors. Persist raw responses only when useful and safe.

## Centralize selection and configuration

Choose the provider in application configuration, persisted account or tenant settings, or a gateway that owns dispatch. Keep provider selection out of entry points. Use the application's existing secret configuration and use provider-specific types when credentials or settings differ.

Prefer concrete types or an enum for a closed set of providers. Use a small application-owned trait when dynamic substitution or extensibility provides value. Design the interface around the operations the application needs. Follow the [reliability guide](reliability.md) for timeouts, retries, and delivery behavior.

## Decompose complex providers

Start with `providers/stripe.rs`. As distinct responsibilities emerge, preserve the caller-facing provider interface and move implementation details into private submodules:

```text
providers/stripe/
├── mod.rs
├── client.rs
├── charge.rs
├── refund.rs
├── webhooks.rs
└── errors.rs
```

Implement only operations the application uses and group them by responsibility. Apply the [production complexity rules](../rust/complexity.md) to provider modules.

## Other domains

```text
src/services/
├── ai/
│   ├── mod.rs
│   ├── generate.rs
│   ├── embed.rs
│   ├── gateway.rs
│   └── providers/
│       ├── mod.rs
│       ├── openai.rs
│       └── anthropic.rs
├── messaging/
│   ├── mod.rs
│   ├── send_message.rs
│   └── providers/
│       ├── mod.rs
│       └── twilio.rs
└── storage/
    ├── mod.rs
    ├── upload.rs
    ├── download.rs
    └── providers/
        ├── mod.rs
        └── s3.rs
```
