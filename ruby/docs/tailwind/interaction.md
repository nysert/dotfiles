# Interaction

Detailed guidance referenced by `docs/tailwind.md`. Read this file only when this topic is relevant to the task.

# Interaction design
## Borders

Avoid harsh pure-black borders unless explicitly required.

Prefer subtle contextual borders for fields and surfaces such as:

```text
border-slate-200
border-slate-300
dark:border-white/10
```

Use borders for:

- Inputs and selects.
- Textareas.
- Secondary buttons when they intentionally mirror input-like controls.
- Cards and surfaces.
- Dividers.
- Tables where structure needs them.

Primary and destructive buttons should normally get separation from background contrast, shadows, and interaction states rather than borders.

Secondary buttons are the exception: prefer the same subtle input border treatment, typically `border border-slate-300 bg-white` in light mode and the equivalent input border/surface tokens in dark mode.

---
## Shadows

Use shadows deliberately and consistently:

```text
shadow-sm → inputs, selects, normal buttons, cards
shadow    → slightly elevated surfaces
shadow-md → button hover, menus, more elevated states
shadow-lg → dialogs, dropdowns, floating surfaces
```

Default tactile button pattern:

```text
shadow-sm hover:shadow-md active:shadow-sm
```

Inputs and selects normally keep a stable `shadow-sm`; focus should be communicated by border/ring changes rather than by making the field float dramatically.

Do not make every surface float.

---
## Radius

Use one default radius for application controls.

Recommended default:

```text
inputs/selects/buttons → rounded-md
cards                  → rounded-xl
badges                  → rounded-md or rounded-full
dialogs                 → rounded-xl or rounded-2xl
```

Do not mix `rounded-md`, `rounded-lg`, and custom radii across otherwise equivalent fields and buttons without a deliberate reason.

---
## Hover

Every clickable element should visibly respond to interaction.

Use restrained changes such as:

```text
hover:bg-*
hover:text-*
hover:shadow-*
```

The hover state must remain visually distinct from the surface behind the control.

Example:

```text
page:              bg-slate-50
secondary button:  border border-slate-300 bg-white
button hover:      hover:bg-slate-100 hover:shadow-md
```

Avoid a hover color that matches the page background and makes the control visually disappear.

Do not unexpectedly change semantic color on hover.

---
## Active / pressed

Prefer subtle tactile feedback:

```text
active:translate-y-px
active:shadow-sm
```

Avoid dramatic effects like `active:scale-90` for normal application controls.

---
## Focus

Never remove focus indicators without replacing them.

Prefer:

```text
focus-visible:outline-none
focus-visible:ring-2
focus-visible:ring-*/40
```

Interactive controls must remain keyboard-accessible.

---
## Disabled

Disabled controls should be visually clear and remain legible.

Typical pattern:

```text
disabled:pointer-events-none disabled:opacity-50
```

---
## Transitions

Prefer restrained transitions:

```text
transition
transition-colors
transition-shadow
```

Routine UI feedback should feel immediate.

---
