# Rails Hotwire

Detailed guidance referenced by `docs/frontend.md`. Read this file only when this topic is relevant to the task.

## Rails-first frontend

Prefer Rails and Hotwire before introducing client-side frameworks or large JavaScript abstractions.

Use:

- ERB for server-rendered views.
- Turbo Drive for navigation.
- Turbo Frames for independently replaceable regions.
- Turbo Streams for server-driven DOM updates.
- Stimulus for local interaction and browser state.

Do not introduce React, Vue, Svelte, or another frontend framework for behavior that the existing Rails stack handles cleanly unless the project already uses that framework for the relevant area.

---
## Semantic HTML

Use the most appropriate HTML element for the interaction.

Prefer:

```html
<button type="button">Open menu</button>
<a href="/appointments">Appointments</a>
```

over clickable generic elements such as:

```html
<div role="button">Open menu</div>
```

Use native semantics before ARIA.

Add ARIA only when native HTML cannot express the behavior.

---
## ERB

Keep templates focused on presentation.

Avoid substantial business logic in ERB.

Prefer:

- Prepared values from controllers/services.
- Small helpers for presentation-only formatting.
- Reusable partials or existing ViewComponents when repetition becomes meaningful.

Do not hide application workflows inside helpers or templates.

Avoid deeply nested conditional markup when the same result can be expressed through a clearer partial/component boundary.

---
## Turbo
### Turbo Drive

Prefer normal Rails navigation and let Turbo Drive accelerate it.

Do not replace normal links/forms with custom fetch/AJAX code without a concrete reason.
### Turbo Frames

Use Turbo Frames when a region of the page:

- Has an independent navigation lifecycle.
- Can be replaced without replacing the whole page.
- Represents a coherent piece of UI.

Avoid excessive nested frames.

Frames should have stable, meaningful IDs.
### Turbo Streams

Use Turbo Streams for server-driven DOM changes such as:

- Append.
- Prepend.
- Replace.
- Remove.
- Update.

Prefer server-rendered stream responses over recreating server-owned markup in JavaScript.

Keep stream targets stable and predictable.

---
