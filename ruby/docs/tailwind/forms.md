# Forms

Detailed guidance referenced by `docs/tailwind.md`. Read this file only when this topic is relevant to the task.

# Forms
## One visual system for single-line controls

All single-line form controls must share the same geometry and base styling.

This applies to:

- Text inputs.
- Email inputs.
- URL inputs.
- Password inputs.
- Number inputs.
- Date/time inputs when practical.
- Selects.
- Combobox triggers.
- Other input-like single-line controls.

The default control contract is:

Long example moved to `docs/tailwind/examples.md` → **One visual system for single-line controls — example 1**.

Do not rely on browser-default height, padding, border, or shadow.

Do not create a field with only a layout class such as:

```html
<input class="w-full" />
```

when neighboring fields use the standard field styling.

That is a common cause of one generated input looking visibly different from the rest of the form.

---
## Canonical single-line input

A typical input style is:

Long example moved to `docs/tailwind/examples.md` → **Canonical single-line input — example 2**.

When semantic theme utilities exist, prefer them.

---
## Selects must match inputs

A select placed beside an input must have the same height, radius, border, shadow, typography, and focus treatment.

Example:

Long example moved to `docs/tailwind/examples.md` → **Selects must match inputs — example 3**.

Avoid styling one field with `py-2`, another with `py-1.5`, and another with browser defaults. Explicit `h-10` makes single-line controls predictable across input types and browsers.

---
## Textareas and multi-line controls

Textareas should reuse the same:

- Border.
- Radius.
- Background.
- Text.
- Shadow.
- Placeholder.
- Focus treatment.

They should **not** use the fixed single-line `h-10` height.

Use a sensible minimum height such as `min-h-24` and vertical padding such as `py-2`.

---
## Labels and field spacing

Use consistent field structure:

```html
<label class="block">
  <span class="text-sm font-medium text-slate-700">Endpoint URL</span>
  <input class="mt-1 ..." />
</label>
```

Equivalent fields in the same form should use the same label typography and label-to-control spacing.

For horizontally paired controls, preserve the same control height:

```html
<div class="grid gap-4 sm:grid-cols-2">...</div>
```

---
## Reuse the field primitive

When the same control class list appears repeatedly, centralize it through the project's existing UI abstraction such as a form builder, helper, partial, or component.

Generated UI code should search for and reuse the canonical field primitive before writing a new class list.

Consistency is more important than inventing a slightly different field style for a new page.

---
