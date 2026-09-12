# Buttons

Detailed guidance referenced by `docs/tailwind.md`. Read this file only when this topic is relevant to the task.

# Buttons
## Shared button geometry

Buttons should align visually with single-line form controls without looking like form fields.

Default application buttons should normally use:

```text
h-10
inline-flex items-center justify-center
rounded-md
px-4
text-sm font-medium
shadow-sm
transition
```

This gives buttons the same height and radius as inputs/selects while preserving a distinct button treatment through background, typography, and interaction states.

Use compact buttons such as `h-8 px-3 text-xs` only for intentionally compact controls such as table actions, toolbar actions, or small `Add` buttons.

Do not let ordinary page actions drift into different heights because one uses `py-2`, another uses `py-1.5`, and another relies on browser defaults.

---
## Buttons use shadow, not borders

Normal buttons should **not** use borders for visual structure.

Prefer:

- Background contrast.
- `shadow-sm` at rest.
- A stronger hover background.
- `hover:shadow-md` where appropriate.
- Subtle pressed feedback.
- A visible focus ring.

Avoid:

```text
border
border-gray-300
border-blue-700
border-red-700
```

on normal primary, secondary, and destructive buttons.

Borders remain appropriate for form controls, cards, dividers, and other surfaces.

Ghost/icon buttons are intentionally flatter and may omit shadows when their lower visual priority is clear.

---
## Primary buttons

The primary action in a page or action group should normally use the application's primary color.

If no semantic project palette exists, blue is a reasonable default:

Long example moved to `docs/tailwind/examples.md` → **Primary buttons — example 1**.

If semantic theme utilities exist, prefer them over hard-coding a Tailwind palette into every component.

Do not use success/green styling merely because an action saves or creates something. Reserve success styling for actions or states whose semantics are genuinely success-oriented.

---
## Secondary buttons

Secondary actions should remain clearly visible against both the page background and card surfaces.

A good default is:

Long example moved to `docs/tailwind/examples.md` → **Secondary buttons — example 2**.

The hover state must remain distinct from the page behind the button.

For example, if the page uses `bg-slate-50`, avoid `hover:bg-slate-50` on a white secondary button because the control can visually disappear into the page. Prefer a stronger contrast change such as `hover:bg-slate-100`, optionally combined with `hover:shadow-md`.

---
## Destructive buttons

Destructive actions should use the same geometry and shadow treatment with danger semantics:

Long example moved to `docs/tailwind/examples.md` → **Destructive buttons — example 3**.

---
## Ghost buttons

Ghost buttons are appropriate for low-priority, toolbar, compact, and icon actions.

They may intentionally omit the default button shadow when a flatter treatment better communicates lower priority.

They still require hover, active, focus, and disabled states.

Do not use ghost styling for ordinary page-level actions such as Save, Cancel, Create, or Delete.

---
## Button hierarchy

Usually only one action in a group should visually dominate.

Typical hierarchy:

```text
Save / Create / Continue → primary
Cancel                   → secondary
Delete                   → destructive
More / icon action       → ghost
```

Avoid several equally prominent colored buttons next to each other.

---
