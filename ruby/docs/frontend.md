# Frontend Guidelines

Use this file when creating or modifying browser-side behavior, HTML structure, ERB, Turbo, Stimulus, JavaScript, forms, or interactive UI.

For visual styling, themes, colors, and Tailwind conventions, also read:

`docs/tailwind.md`

The frontend should remain Rails-first, server-driven, and progressively enhanced unless an existing part of the application intentionally uses a different approach.

---

## Core principles

Prefer, in this order:

1. Semantic HTML.
2. Standard Rails forms and links.
3. Turbo navigation and server-rendered updates.
4. Stimulus for local browser behavior.
5. Custom JavaScript only when the above are insufficient.

Keep application and business logic on the server when the server owns the behavior.

Do not move business rules into JavaScript merely to avoid a server request.

---

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

# Stimulus

Use Stimulus for local interaction such as:

- Menus.
- Dialog triggers.
- Tabs.
- Auto-submit behavior.
- Clipboard actions.
- Keyboard shortcuts.
- Small local state.
- DOM coordination.

Stimulus controllers should be small and focused.

Prefer one clear responsibility per controller.

Use:

- Targets.
- Values.
- Classes.
- Actions.

instead of repeatedly querying the DOM with fragile selectors.

---

## Always use the Rails Stimulus generator

When creating a new Stimulus controller, use:

```sh
bin/rails generate stimulus NAME
```

or the shorter equivalent:

```sh
bin/rails g stimulus NAME
```

Do **not** manually create new controller files under:

```text
app/javascript/controllers/
```

unless there is a specific reason the Rails generator cannot be used.

The generator is the source of truth for:

- Controller filenames.
- Stimulus controller identifiers.
- Nested-controller naming.
- Manifest registration.
- Collision checks.
- Project-specific Stimulus generator behavior.

This avoids manually introducing a controller whose filename, identifier, or manifest entry does not match Rails/Stimulus conventions.

---

## Stimulus generator examples

For a top-level controller:

```sh
bin/rails generate stimulus chat
```

creates:

```text
app/javascript/controllers/chat_controller.js
```

and the controller is referenced from HTML as:

```html
<div data-controller="chat">
```

For a nested controller:

```sh
bin/rails generate stimulus nested/chat
```

creates:

```text
app/javascript/controllers/nested/chat_controller.js
```

with a Stimulus identifier equivalent to:

```html
<div data-controller="nested--chat">
```

The generated controller will resemble:

```js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested--chat"
export default class extends Controller {
  connect() {
  }
}
```

Do not guess nested Stimulus identifiers manually.

Use the generator so Rails establishes the correct mapping.

---

## Stimulus manifest

The Stimulus manifest/index may be generated automatically by Rails.

For example:

```js
// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import Nested__ChatController from "./nested/chat_controller"
application.register("nested--chat", Nested__ChatController)
```

Treat generated manifest files as generated code.

Do not manually edit generated Stimulus registration entries unless the project's existing setup explicitly requires manual registration.

When adding a controller, prefer:

```sh
bin/rails generate stimulus NAME
```

so the manifest is updated as part of the normal generator workflow.

If a controller file was added or moved outside the generator workflow and the manifest needs to be synchronized, run:

```sh
bin/rails stimulus:manifest:update
```

Prefer regenerating/updating the manifest over hand-editing it.

---

## Existing Stimulus controllers

Do not run the generator merely to edit an existing controller.

For an existing controller:

1. Locate the existing generated controller.
2. Preserve its current identifier/path unless the task requires renaming it.
3. Modify the existing controller directly.
4. Update the manifest only if its file path or registration changes.

If renaming or moving a Stimulus controller, ensure all of the following remain synchronized:

- Controller file path.
- `data-controller` identifier.
- `data-action` references.
- Target/value/class attributes.
- Manifest registration.

Run:

```sh
bin/rails stimulus:manifest:update
```

when needed after structural changes.

---

## Stimulus DOM conventions

Prefer:

```html
<div data-controller="dropdown">
  <button data-action="dropdown#toggle">Menu</button>

  <div data-dropdown-target="menu">
    ...
  </div>
</div>
```

over JavaScript that depends on incidental CSS classes or DOM positions.

Do not use visual Tailwind classes as JavaScript selectors when stable Stimulus targets or data attributes are available.

---

## JavaScript state

Keep browser-only state in the browser.

Keep authoritative application state on the server.

Examples of browser-only state:

- Whether a menu is open.
- Which tab is temporarily selected.
- Whether a tooltip is visible.
- Temporary input presentation state.

Examples of server-owned state:

- Appointment status.
- Subscription status.
- Permissions.
- Prices.
- Inventory.
- Account settings.
- Persisted workflow progress.

Do not duplicate authoritative server state in long-lived browser state without a clear need.

---

## Forms

Prefer Rails form helpers and standard form submission behavior.

Use server-side validation as the source of truth.

Client-side validation may improve UX, but must not be the only validation.

On validation failure:

- Preserve user input.
- Show useful field-level errors when appropriate.
- Use semantic error markup.
- Keep focus behavior accessible.

Do not disable server validations because equivalent JavaScript exists.

---

## DOM IDs

Use stable IDs when Turbo or JavaScript targets specific elements.

Prefer Rails helpers such as:

```ruby
dom_id(record)
```

when appropriate.

Do not generate unstable IDs based on array positions or presentation order if Turbo updates depend on them.

---

## Events

Use normal DOM/Stimulus events to communicate between frontend behaviors when necessary.

Avoid tightly coupling one Stimulus controller to another controller's internal implementation.

Prefer explicit custom events for cross-controller communication.

---

## Accessibility

Interactive frontend work must preserve:

- Keyboard access.
- Visible focus.
- Semantic controls.
- Correct labels.
- Appropriate dialog behavior.
- Reduced-motion preferences where animations are meaningful.
- Useful screen-reader state.

Do not use hover as the only way to reveal required functionality.

Do not communicate state through color alone.

---

## Progressive enhancement

Where practical, core flows should still make sense without custom JavaScript.

JavaScript should enhance Rails behavior rather than replace it by default.

A temporary JavaScript failure should not silently corrupt server state.

---

## Performance

Avoid shipping unnecessary JavaScript.

Prefer server rendering for content already known by Rails.

Do not add polling when Turbo Streams, scheduled refreshes, or event-driven updates solve the problem more cleanly.

Avoid repeated DOM scans when Stimulus targets can provide direct references.

---

## Frontend completion checklist

Before considering frontend work complete, verify:

- [ ] Semantic HTML is used.
- [ ] Rails/Hotwire was preferred before custom JavaScript.
- [ ] New Stimulus controllers were created with `bin/rails generate stimulus`.
- [ ] Nested Stimulus controller identifiers were not guessed manually.
- [ ] Generated Stimulus manifest files were not hand-edited unnecessarily.
- [ ] `bin/rails stimulus:manifest:update` was run when structural controller changes required it.
- [ ] Stimulus controllers remain small and focused.
- [ ] Server-owned business rules remain on the server.
- [ ] Stable DOM IDs and targets are used.
- [ ] Forms retain server-side validation.
- [ ] Keyboard navigation works.
- [ ] Focus states remain visible.
- [ ] Turbo updates target stable elements.
- [ ] JavaScript does not depend on fragile styling selectors.
- [ ] `docs/tailwind.md` was followed for visual changes.
