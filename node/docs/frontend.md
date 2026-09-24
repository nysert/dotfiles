# Frontend Guidelines

Use this file when Node.js work includes browser code, client/server boundaries, forms, DOM behavior, or interactive UI.

Follow the frontend framework and component patterns already used by the project.

## Core rules

- Keep secrets, private credentials, and server-only dependencies out of browser bundles.
- Make client/server boundaries explicit.
- Validate authorization and security-sensitive rules on the server even when the client also validates them.
- Prefer server-rendered or static behavior when the active framework supports it and client-side state is unnecessary.
- Keep client state local unless several parts of the UI genuinely require shared state.
- Preserve accessibility.
- Prefer semantic elements.
- Provide labels for controls.
- Preserve keyboard operation and focus behavior.
- Provide useful loading, empty, success, and error states.
- Avoid direct DOM manipulation when the active framework provides a declarative mechanism.
- Do not expose internal exception details to users.

## Framework conventions

Prefer the project's existing framework conventions and nearby components over generic advice from this document.

Do not introduce a second state-management, form, routing, or styling approach without a concrete need.
