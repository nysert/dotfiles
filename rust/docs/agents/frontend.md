# Browser and WASM Frontend

Read for Rust UI components, browser/WASM behavior, forms, or client/server boundaries.

- Follow the existing UI framework and patterns (e.g. Leptos, Yew, or Dioxus); do not migrate frameworks incidentally.
- Keep components focused and move complex domain behavior into testable functions.
- Handle loading, error, empty, and success states explicitly.
- Follow framework state/reactivity semantics to avoid stale state and needless recomputation.
- Use semantic controls, accessible labels, keyboard navigation, and proper focus handling.
- Validate browser input on the server; client checks are not authorization.
- Never embed private credentials in browser/WASM bundles.
- Verify relevant browser/WASM targets; native `cargo test` alone does not exercise them.
- Respect SSR and hydration behavior when the framework supports it.
