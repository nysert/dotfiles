# Browser Behavior

Detailed guidance referenced by `docs/frontend.md`. Read this file only when this topic is relevant to the task.

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
