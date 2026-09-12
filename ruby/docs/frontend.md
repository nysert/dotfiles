# Frontend Guidelines

Use this file when creating or modifying browser-side behavior, HTML structure, ERB, Turbo, Stimulus, JavaScript, forms, or interactive UI.

For visual styling, themes, colors, and Tailwind conventions, also read `docs/tailwind.md`.

The frontend should remain Rails-first, server-driven, and progressively enhanced unless an existing area intentionally uses a different approach.

## Core rules

Prefer, in order:

1. Semantic HTML.
2. Standard Rails forms and links.
3. Turbo navigation and server-rendered updates.
4. Stimulus for local browser behavior.
5. Custom JavaScript only when the above are insufficient.

Keep authoritative application/business state on the server. Do not move business rules into JavaScript merely to avoid a server request.

Use native HTML semantics before ARIA. Preserve keyboard access and visible focus.

New Stimulus controllers must be created with `bin/rails generate stimulus NAME`; do not guess nested identifiers or hand-edit generated manifest entries without a concrete need.

## Read when relevant

- Rails-first UI, semantic HTML, ERB, and Turbo → `docs/frontend/rails-hotwire.md`
- Stimulus creation, manifests, identifiers, targets, and examples → `docs/frontend/stimulus.md`
- Browser state, forms, DOM IDs/events, accessibility, progressive enhancement, and performance → `docs/frontend/browser-behavior.md`
