# Tailwind / UI Guidelines

Use this file for visual UI work: Tailwind/CSS, themes, colors, forms, buttons, navigation, cards, modals, tables, responsive layouts, and other user-facing styling.

For browser behavior and HTML/ERB/Turbo/Stimulus conventions, also read `docs/frontend.md`.

## Priorities

1. Consistency.
2. Reuse.
3. Clarity.
4. Accessibility.
5. Themeability.
6. Polish.
7. Novelty.

The UI should feel intentionally designed and premium without becoming visually noisy.

## Core rules

- Prefer Tailwind utilities and default scales over arbitrary values.
- Search for and reuse existing components/patterns before creating new ones.
- Never put raw color literals in component/template markup; custom colors belong in the centralized theme/configuration layer.
- Prefer semantic color tokens.
- Every new component must work intentionally in light and dark mode.
- Equivalent controls must share consistent geometry and interaction states.
- Normal buttons use background contrast/shadows rather than borders.
- Preserve visible focus, keyboard access, semantic HTML, sufficient contrast, and readable disabled states.
- Avoid custom CSS unless Tailwind, an existing component, or a theme token cannot express the requirement clearly.

## Read when relevant

- Colors, semantic tokens, and light/dark themes → `docs/tailwind/colors-themes.md`
- Button geometry, hierarchy, states, and examples → `docs/tailwind/buttons.md`
- Borders, shadows, radius, hover/active/focus/disabled/transitions → `docs/tailwind/interaction.md`
- Inputs, selects, textareas, labels, and field reuse → `docs/tailwind/forms.md`
- Cards, typography, spacing, arbitrary values, CSS, responsive design, accessibility, and completion checks → `docs/tailwind/layout-accessibility.md`
- Long concrete examples → `docs/tailwind/examples.md`

## Core rule

**Theme colors are configuration, not component implementation details.**
