# Colors Themes

Detailed guidance referenced by `docs/tailwind.md`. Read this file only when this topic is relevant to the task.

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

Long example moved to `docs/tailwind/examples.md` → **Prefer semantic tokens — example 1**.

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

Long example moved to `docs/tailwind/examples.md` → **Light and dark mode — example 2**.

---
