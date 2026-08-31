# Tailwind / UI Guidelines

Read and follow this file whenever modifying HTML, ERB, ViewComponents, Tailwind, CSS, forms, navigation, or any user-facing UI.

Priority:

1. Consistency
2. Reuse
3. Clarity
4. Accessibility
5. Themeability
6. Polish
7. Novelty

The UI should feel intentionally designed and premium without becoming visually noisy.

---

## Tailwind First

Use Tailwind utilities whenever possible.

Prefer Tailwind's default scales for:

- colors
- spacing
- sizing
- typography
- border radius
- shadows
- opacity
- breakpoints
- transitions

Prefer:

```html
<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
```

over:

```html
<div class="rounded-[11px] border-[#e3e3e3] bg-[#fff] p-[23px]">
```

Avoid arbitrary values when a reasonable Tailwind default exists.

---

## Reuse Before Creating

Before creating a new UI pattern, search for an existing component or equivalent implementation.

Reuse or extend existing:

- buttons
- inputs
- selects
- badges
- cards
- dialogs
- dropdowns
- alerts
- tables
- pagination
- navigation

Do not recreate the same visual pattern independently in multiple places.

If the project already has a `Button`, `Input`, `Card`, etc., use it rather than duplicating its Tailwind classes.

---

## Keep Classes Clean

Avoid duplicated, contradictory, or unnecessarily long class lists.

Use a reasonably consistent conceptual order:

```text
layout → size → spacing → typography → background → border → radius → shadow → states → responsive → dark
```

Follow the project's formatter and existing conventions.

Do not create noisy diffs only to reorder classes.

---

# Colors and Themes

## Never Inline Raw Colors

Raw color values must never appear in component/template markup.

Forbidden:

```text
bg-[#181818]
text-[#777]
border-[rgb(...)]
bg-[hsl(...)]
text-[oklch(...)]
style="color: #..."
```

This prohibition applies to:

- hex
- rgb/rgba
- hsl/hsla
- oklch
- any other literal color syntax

**Raw colors belong only in the centralized theme/configuration layer.**

This keeps theme changes consistent and easy to make.

---

## Color Selection Order

Before adding a color:

1. Reuse an existing semantic project token.
2. Otherwise use a suitable Tailwind default color.
3. Otherwise reuse the closest existing semantic token.
4. Only then add a new centralized theme token.

Do not create custom colors for tiny shade differences when a standard Tailwind color is sufficient.

---

## Custom Colors Must Be Centralized

If a custom color is genuinely needed, define it in the project's existing theme/config file, for example:

```text
app/assets/tailwind/application.css
app/assets/stylesheets/application.css
theme.css
tailwind.css
tailwind.config.*
```

Do not create a second theme system if one already exists.

Good:

```html
<button class="bg-success text-success-foreground">
```

Bad:

```html
<button class="bg-[#16a34a] text-white">
```

---

## Prefer Semantic Tokens

Custom theme colors should describe purpose, not literal appearance.

Prefer:

```text
primary
primary-hover
primary-foreground

success
success-hover
success-border
success-foreground

danger
warning
info

background
surface
surface-raised
foreground
muted
border
```

Avoid:

```text
green-1
dark-green
my-gray
special-button-color
```

Components should describe what a color means, not which shade currently implements it.

---

## Light and Dark Mode

Every new component must work correctly in both light and dark mode.

Do not assume:

- white backgrounds
- black text
- black borders

If semantic tokens already handle themes, prefer:

```html
<div class="border-border bg-surface text-foreground">
```

If the project uses `dark:` directly, use theme-safe Tailwind classes:

```html
<div class="border-gray-200 bg-white text-gray-950 dark:border-white/10 dark:bg-gray-950 dark:text-white">
```

Do not simply invert colors. Both themes should look intentional.

When no project-specific direction exists, a reasonable neutral default is:

```text
Light:
page       bg-gray-50
surface    bg-white
border     border-gray-200
primary    text-gray-950
secondary  text-gray-600
muted      text-gray-500

Dark:
page       dark:bg-gray-950
surface    dark:bg-gray-900
border     dark:border-white/10
primary    dark:text-white
secondary  dark:text-gray-300
muted      dark:text-gray-400
```

---

# Buttons

## Buttons Must Feel Premium

Do not default to flat controls such as:

```html
<button class="border border-black px-4 py-2">
```

or:

```html
<button class="bg-black px-4 py-2 text-white">
```

Buttons should normally have:

- semantic background color
- related border color
- appropriate foreground contrast
- subtle shadow/depth
- hover feedback
- active/pressed feedback
- visible keyboard focus
- disabled state
- theme support
- restrained transitions

Premium should come from good hierarchy, spacing, typography, borders, shadows, and interaction states.

Do **not** interpret premium as automatically adding gradients, glassmorphism, glow effects, or large shadows.

---

## Primary / Success Buttons

Positive primary actions such as Save, Create, Continue, Confirm, Add, Submit, and Publish should use a clear success/primary treatment.

If no semantic project palette exists, an emerald Tailwind treatment is a reasonable default:

```html
<button
  class="
    inline-flex items-center justify-center gap-2
    rounded-lg border border-emerald-700
    bg-emerald-600 px-4 py-2
    text-sm font-semibold text-white
    shadow-sm transition
    hover:bg-emerald-500 hover:shadow-md
    active:translate-y-px active:shadow-sm
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-emerald-500/40
    disabled:pointer-events-none disabled:opacity-50
    dark:border-emerald-400/30
    dark:bg-emerald-500
    dark:text-emerald-950
    dark:hover:bg-emerald-400
  "
>
  Save changes
</button>
```

If semantic theme utilities exist, use those instead of hard-coding a Tailwind palette into every component.

---

## Secondary Buttons

Secondary actions should still feel designed:

```html
<button
  class="
    inline-flex items-center justify-center gap-2
    rounded-lg border border-gray-300
    bg-white px-4 py-2
    text-sm font-medium text-gray-700
    shadow-sm transition
    hover:bg-gray-50 hover:text-gray-950 hover:shadow
    active:translate-y-px
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-gray-400/30
    disabled:pointer-events-none disabled:opacity-50
    dark:border-white/10
    dark:bg-white/5 dark:text-gray-200
    dark:hover:bg-white/10 dark:hover:text-white
  "
>
  Cancel
</button>
```

Avoid harsh black rectangular borders as the default secondary-button style.

---

## Destructive Buttons

Destructive actions should use the same polished treatment with danger semantics:

```html
<button
  class="
    inline-flex items-center justify-center gap-2
    rounded-lg border border-red-700
    bg-red-600 px-4 py-2
    text-sm font-semibold text-white
    shadow-sm transition
    hover:bg-red-500 hover:shadow-md
    active:translate-y-px active:shadow-sm
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-red-500/40
    disabled:pointer-events-none disabled:opacity-50
    dark:border-red-400/30
    dark:bg-red-500
    dark:hover:bg-red-400
  "
>
  Delete
</button>
```

---

## Ghost Buttons

Ghost buttons are appropriate for low-priority, toolbar, compact, and icon actions.

They still require hover and focus feedback.

Do not use ghost styling for every action.

---

## Button Hierarchy

Usually only one action in a group should visually dominate.

Typical hierarchy:

```text
Save changes → primary/success
Cancel       → secondary
Delete       → destructive
More         → ghost
```

Avoid several equally prominent colored buttons next to each other.

---

# Interaction Design

## Borders

Avoid harsh pure-black borders unless explicitly required.

Prefer subtle contextual borders such as:

```text
border-gray-200
border-gray-300
dark:border-white/10
```

Colored controls should generally use a border related to their semantic color.

---

## Shadows

Use shadows deliberately:

```text
shadow-sm → controls, buttons, cards
shadow    → slightly elevated surfaces
shadow-md → hover/elevated state
shadow-lg → dialogs, dropdowns, floating surfaces
```

Useful tactile pattern:

```text
shadow-sm hover:shadow-md active:shadow-sm
```

Do not make every surface float.

---

## Radius

Prefer the standard Tailwind radius scale:

```text
rounded-md
rounded-lg
rounded-xl
rounded-2xl
rounded-full
```

Typical defaults:

```text
buttons/inputs → rounded-lg
cards          → rounded-xl
badges         → rounded-md or rounded-full
dialogs        → rounded-xl or rounded-2xl
```

---

## Hover

Every clickable element should visibly respond to interaction.

Use restrained changes such as:

```text
hover:bg-*
hover:text-*
hover:border-*
hover:shadow-*
```

Do not unexpectedly change semantic color on hover.

---

## Active / Pressed

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

# Forms

Inputs must work well in both themes and have clear focus states.

A typical style is:

```html
<input
  class="
    w-full rounded-lg
    border border-gray-300
    bg-white px-3 py-2
    text-sm text-gray-950
    shadow-sm outline-none transition
    placeholder:text-gray-400
    focus:border-emerald-500
    focus:ring-2 focus:ring-emerald-500/20
    dark:border-white/10
    dark:bg-white/5 dark:text-white
    dark:placeholder:text-gray-500
    dark:focus:border-emerald-400
    dark:focus:ring-emerald-400/20
  "
>
```

When semantic theme utilities exist, prefer them.

---

# Cards and Surfaces

Cards should rely on restrained contrast, borders, and shadows:

```html
<div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-white/10 dark:bg-gray-900">
```

Avoid unnecessary:

- heavy gradients
- huge shadows
- repeated nested borders
- decorative effects without purpose

---

# Typography and Spacing

Prefer Tailwind's standard type scale:

```text
text-xs
text-sm
text-base
text-lg
text-xl
text-2xl
```

Prefer standard weights:

```text
font-medium
font-semibold
font-bold
```

Prefer standard spacing:

```text
gap-1 gap-2 gap-3 gap-4 gap-6 gap-8
p-2 p-3 p-4 p-6 p-8
px-3 px-4 px-6
py-2 py-3
```

Consistency matters more than unnecessary pixel-level adjustments.

---

# Arbitrary Values

Arbitrary **layout** values are allowed only when:

- implementing an externally specified design
- exact geometry is genuinely necessary
- integrating with a third-party component
- no reasonable Tailwind token exists

Avoid unnecessary values like:

```text
w-[437px]
top-[13px]
text-[15px]
rounded-[11px]
```

Arbitrary **color** values are prohibited in component markup.

Never use:

```text
bg-[#...]
text-[#...]
border-[#...]
ring-[#...]
fill-[#...]
stroke-[#...]
```

Custom colors must be centralized.

---

# Custom CSS

Custom CSS should be uncommon.

Before adding it, check:

1. Can Tailwind already express this?
2. Does an existing component solve it?
3. Can a theme token solve it?
4. Is custom CSS genuinely clearer?

Prefer reusable components over ad-hoc CSS aliases for repeated utility lists.

---

# Responsive Design

Build mobile-first.

Prefer progressive breakpoints:

```html
<div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
```

Avoid separate mobile/desktop markup when responsive utilities are sufficient.

Avoid unnecessary breakpoint proliferation.

---

# Accessibility

Always preserve:

- semantic HTML
- keyboard navigation
- visible focus states
- sufficient contrast
- readable disabled states
- form labels
- appropriate `aria-*` attributes where necessary

Do not communicate important state using color alone.

---

# Completion Checklist

Before considering UI work complete, verify:

- [ ] Existing components were reused where practical.
- [ ] Tailwind defaults were preferred.
- [ ] No inline raw colors were introduced.
- [ ] No arbitrary Tailwind colors such as `bg-[#...]` were introduced.
- [ ] Custom colors, if any, are centralized.
- [ ] Semantic color names are used where appropriate.
- [ ] Light mode looks intentional.
- [ ] Dark mode looks intentional.
- [ ] Theme changes remain easy to make centrally.
- [ ] Buttons have clear hierarchy and premium interaction states.
- [ ] Hover, active, focus, and disabled states exist where appropriate.
- [ ] Keyboard focus remains visible.
- [ ] Spacing and typography use Tailwind's standard scales.
- [ ] Custom CSS and arbitrary values were avoided unless necessary.
- [ ] The UI feels like one consistent design system.

## Core Rule

**Theme colors are configuration, not component implementation details.**

Changing the application's palette should primarily require changing the centralized theme/configuration layer, not searching through individual templates and components.
