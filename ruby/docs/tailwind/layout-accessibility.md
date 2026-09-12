# Layout Accessibility

Detailed guidance referenced by `docs/tailwind.md`. Read this file only when this topic is relevant to the task.

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
