# Tailwind / UI Guidelines

Use this file whenever creating or modifying:

- HTML.
- ERB templates.
- ViewComponents.
- Tailwind CSS.
- CSS.
- Forms.
- Buttons.
- Navigation.
- Cards.
- Modals.
- Tables.
- Responsive layouts.
- Light/dark themes.
- Any user-facing UI.

Priority:

1. Consistency.
2. Reuse.
3. Clarity.
4. Accessibility.
5. Themeability.
6. Polish.
7. Novelty.

The UI should feel intentionally designed and premium without becoming visually noisy.

---

## Tailwind first

Use Tailwind utilities whenever possible.

Prefer Tailwind's default scales for:

- Colors.
- Spacing.
- Sizing.
- Typography.
- Border radius.
- Shadows.
- Opacity.
- Breakpoints.
- Transitions.

Prefer:

```html
<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm"></div>
```

over:

```html
<div class="rounded-[11px] border-[#e3e3e3] bg-[#fff] p-[23px]"></div>
```

Avoid arbitrary values when a reasonable Tailwind default exists.

---

## Reuse before creating

Before creating a new UI pattern, search for an existing component or equivalent implementation.

Reuse or extend existing:

- Buttons.
- Inputs.
- Selects.
- Badges.
- Cards.
- Dialogs.
- Dropdowns.
- Alerts.
- Tables.
- Pagination.
- Navigation.

Do not recreate the same visual pattern independently in multiple places.

If the project already has a `Button`, `Input`, `Card`, etc., use it rather than duplicating its Tailwind classes.

---

## Keep classes clean

Avoid duplicated, contradictory, or unnecessarily long class lists.

Use a reasonably consistent conceptual order:

```text
layout → size → spacing → typography → background → border → radius → shadow → states → responsive → dark
```

Follow the project's formatter and existing conventions.

Do not create noisy diffs only to reorder classes.

---

# Colors and themes

## Never inline raw colors

Raw color values must never appear in component or template markup.

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

- Hex.
- `rgb()` / `rgba()`.
- `hsl()` / `hsla()`.
- `oklch()`.
- Any other literal color syntax.

**Raw colors belong only in the centralized theme/configuration layer.**

This keeps theme changes consistent and easy to make.

---

## Color selection order

Before adding a color:

1. Reuse an existing semantic project token.
2. Otherwise use a suitable Tailwind default color.
3. Otherwise reuse the closest existing semantic token.
4. Only then add a new centralized theme token.

Do not create custom colors for tiny shade differences when a standard Tailwind color is sufficient.

---

## Custom colors must be centralized

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
<button class="bg-success text-success-foreground"></button>
```

Bad:

```html
<button class="bg-[#16a34a] text-white"></button>
```

---

## Prefer semantic tokens

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

## Light and dark mode

Every new component must work correctly in both light and dark mode.

Do not assume:

- White backgrounds.
- Black text.
- Black borders.

If semantic tokens already handle themes, prefer:

```html
<div class="border-border bg-surface text-foreground"></div>
```

If the project uses `dark:` directly, use theme-safe Tailwind classes:

```html
<div
  class="border-gray-200 bg-white text-gray-950 dark:border-white/10 dark:bg-gray-950 dark:text-white"
></div>
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

```html
<button
  class="
    inline-flex h-10 items-center justify-center gap-2
    rounded-md bg-blue-600 px-4
    text-sm font-medium text-white
    shadow-sm transition
    hover:bg-blue-700 hover:shadow-md
    active:translate-y-px active:shadow-sm
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-blue-500/40
    disabled:pointer-events-none disabled:opacity-50
    dark:bg-blue-500 dark:hover:bg-blue-400
  "
>
  Save destination
</button>
```

If semantic theme utilities exist, prefer them over hard-coding a Tailwind palette into every component.

Do not use success/green styling merely because an action saves or creates something. Reserve success styling for actions or states whose semantics are genuinely success-oriented.

---

## Secondary buttons

Secondary actions should remain clearly visible against both the page background and card surfaces.

A good default is:

```html
<button
  class="
    inline-flex h-10 items-center justify-center gap-2
    rounded-md bg-white px-4
    text-sm font-medium text-slate-700
    shadow-sm transition
    hover:bg-slate-100 hover:text-slate-950 hover:shadow-md
    active:translate-y-px active:shadow-sm
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-slate-400/30
    disabled:pointer-events-none disabled:opacity-50
    dark:bg-white/10 dark:text-slate-200
    dark:hover:bg-white/15 dark:hover:text-white
  "
>
  Cancel
</button>
```

The hover state must remain distinct from the page behind the button.

For example, if the page uses `bg-slate-50`, avoid `hover:bg-slate-50` on a white secondary button because the control can visually disappear into the page. Prefer a stronger contrast change such as `hover:bg-slate-100`, optionally combined with `hover:shadow-md`.

---

## Destructive buttons

Destructive actions should use the same geometry and shadow treatment with danger semantics:

```html
<button
  class="
    inline-flex h-10 items-center justify-center gap-2
    rounded-md bg-red-600 px-4
    text-sm font-medium text-white
    shadow-sm transition
    hover:bg-red-700 hover:shadow-md
    active:translate-y-px active:shadow-sm
    focus-visible:outline-none
    focus-visible:ring-2 focus-visible:ring-red-500/40
    disabled:pointer-events-none disabled:opacity-50
    dark:bg-red-500 dark:hover:bg-red-400
  "
>
  Delete
</button>
```

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
- Cards and surfaces.
- Dividers.
- Tables where structure needs them.

Do **not** use borders on normal buttons. Buttons should get separation from background contrast, shadows, and interaction states instead.

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
secondary button:  bg-white
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

```text
h-10
w-full
rounded-md
border border-slate-300
bg-white
px-3
text-sm
shadow-sm
outline-none
transition
```

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

```html
<input
  class="
    h-10 w-full rounded-md
    border border-slate-300
    bg-white px-3
    text-sm text-slate-950
    shadow-sm outline-none transition
    placeholder:text-slate-400
    focus:border-blue-500
    focus:ring-2 focus:ring-blue-500/20
    disabled:cursor-not-allowed
    disabled:bg-slate-50 disabled:text-slate-500
    dark:border-white/10
    dark:bg-white/5 dark:text-white
    dark:placeholder:text-slate-500
    dark:focus:border-blue-400
    dark:focus:ring-blue-400/20
  "
/>
```

When semantic theme utilities exist, prefer them.

---

## Selects must match inputs

A select placed beside an input must have the same height, radius, border, shadow, typography, and focus treatment.

Example:

```html
<select
  class="
    h-10 w-full rounded-md
    border border-slate-300
    bg-white px-3
    text-sm text-slate-950
    shadow-sm outline-none transition
    focus:border-blue-500
    focus:ring-2 focus:ring-blue-500/20
    disabled:cursor-not-allowed
    disabled:bg-slate-50 disabled:text-slate-500
    dark:border-white/10
    dark:bg-white/5 dark:text-white
    dark:focus:border-blue-400
    dark:focus:ring-blue-400/20
  "
></select>
```

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

# Cards and surfaces

Cards should rely on restrained contrast, borders, and shadows:

```html
<div
  class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-white/10 dark:bg-gray-900"
></div>
```

Avoid unnecessary:

- Heavy gradients.
- Huge shadows.
- Repeated nested borders.
- Decorative effects without purpose.

---

# Typography and spacing

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

# Arbitrary values

Arbitrary **layout** values are allowed only when:

- Implementing an externally specified design.
- Exact geometry is genuinely necessary.
- Integrating with a third-party component.
- No reasonable Tailwind token exists.

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

# Responsive design

Build mobile-first.

Prefer progressive breakpoints:

```html
<div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3"></div>
```

Avoid separate mobile/desktop markup when responsive utilities are sufficient.

Avoid unnecessary breakpoint proliferation.

---

# Accessibility

Always preserve:

- Semantic HTML.
- Keyboard navigation.
- Visible focus states.
- Sufficient contrast.
- Readable disabled states.
- Form labels.
- Appropriate `aria-*` attributes where necessary.

Do not communicate important state using color alone.

---

# Completion checklist

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
- [ ] All equivalent single-line inputs/selects use the same height, radius, border, shadow, typography, and focus treatment.
- [ ] No ordinary field relies on browser-default sizing/styling or only a layout class such as `w-full`.
- [ ] Buttons align to the shared control height where appropriate.
- [ ] Normal buttons use shadow/background contrast instead of borders.
- [ ] Secondary-button hover states remain distinct from the page/card background.
- [ ] Buttons have clear hierarchy and polished interaction states.
- [ ] Hover, active, focus, and disabled states exist where appropriate.
- [ ] Keyboard focus remains visible.
- [ ] Spacing and typography use Tailwind's standard scales.
- [ ] Custom CSS and arbitrary values were avoided unless necessary.
- [ ] The UI feels like one consistent design system.

## Core rule

**Theme colors are configuration, not component implementation details.**

Changing the application's palette should primarily require changing the centralized theme/configuration layer, not searching through individual templates and components.
