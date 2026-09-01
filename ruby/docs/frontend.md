# Frontend Guidelines

Use this file when creating or modifying browser-side behavior, HTML structure, ERB, Turbo, Stimulus, JavaScript, forms, or interactive UI.

For visual styling, themes, colors, and Tailwind conventions, also read `docs/tailwind.md`.

## Core principles

Prefer, in this order:

1. Semantic HTML.
2. Standard Rails forms and links.
3. Turbo navigation and server-rendered updates.
4. Stimulus for local browser behavior.
5. Custom JavaScript only when the above are insufficient.

Keep business logic on the server when the server owns the behavior. Do not move business rules into JavaScript merely to avoid a request.

## Rails-first frontend

Prefer Rails and Hotwire before introducing large client-side frameworks.

Use:

- ERB for server-rendered views.
- Turbo Drive for navigation.
- Turbo Frames for independently replaceable regions.
- Turbo Streams for server-driven DOM updates.
- Stimulus for local interaction and browser state.

Do not introduce React, Vue, Svelte, or similar tooling for behavior the existing Rails stack handles cleanly unless that area already intentionally uses it.

## Semantic HTML

Use native elements before ARIA or clickable generic elements.

Prefer:

```html
<button type="button">Open menu</button>
<a href="/appointments">Appointments</a>
```

over clickable `div` elements.

## ERB

Keep templates focused on presentation.

Avoid substantial business logic in ERB. Prefer prepared values, presentation helpers, partials, or existing ViewComponents.

Do not hide application workflows inside helpers or templates.

## Turbo

Use Turbo Drive for normal navigation.

Use Turbo Frames when a coherent page region has an independent replacement/navigation lifecycle. Keep frame IDs stable and meaningful.

Use Turbo Streams for append, prepend, replace, remove, and update operations driven by the server.

Prefer server-rendered stream responses over recreating server-owned markup in JavaScript.

## Stimulus

Use Stimulus for local behavior such as menus, dialogs, tabs, auto-submit, clipboard actions, keyboard shortcuts, and small browser-only state.

Keep controllers small and focused. Prefer Stimulus targets, values, classes, and actions over fragile DOM queries.

Do not use Tailwind styling classes as JavaScript selectors when stable data attributes or targets are available.

## Browser state vs server state

Browser-only state includes things like open menus, temporary tabs, and tooltips.

Authoritative application state belongs on the server, including appointment status, subscription state, permissions, prices, persisted workflow state, and other domain data.

Do not duplicate server-owned state in long-lived browser state without a clear reason.

## Forms

Prefer Rails form helpers and standard submission behavior.

Server-side validation is the source of truth. Client-side validation may improve UX but must not be the only validation.

On validation failure, preserve input and show useful errors.

## DOM IDs

Use stable DOM IDs where Turbo or JavaScript targets specific elements. Prefer `dom_id(record)` when appropriate.

Do not generate unstable IDs from presentation order when Turbo updates depend on them.

## Accessibility

Preserve keyboard access, visible focus, semantic controls, correct labels, dialog semantics, and reduced-motion preferences where relevant.

Do not use hover or color as the only way to communicate required functionality or state.

## Progressive enhancement

Where practical, core flows should remain understandable without custom JavaScript.

JavaScript should enhance Rails behavior rather than replace it by default.

## Performance

Avoid unnecessary JavaScript. Prefer server rendering for content Rails already knows.

Do not add polling when Turbo Streams or event-driven updates solve the problem more cleanly.

## Completion checklist

- [ ] Semantic HTML is used.
- [ ] Rails/Hotwire was preferred before custom JavaScript.
- [ ] Stimulus controllers remain small and focused.
- [ ] Server-owned business rules remain on the server.
- [ ] Stable DOM IDs and targets are used.
- [ ] Forms retain server-side validation.
- [ ] Keyboard navigation works.
- [ ] Focus states remain visible.
- [ ] Turbo updates target stable elements.
- [ ] JavaScript does not depend on fragile styling selectors.
- [ ] `docs/tailwind.md` was followed for visual changes.
