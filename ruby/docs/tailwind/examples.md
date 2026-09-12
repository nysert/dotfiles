# Tailwind Examples

Concrete examples moved out of the topical `tailwind` guidance files to keep rule context small. Read this file only when a concrete implementation example is useful.

## Primary buttons — example 1

Source topic: `buttons.md`

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

## Secondary buttons — example 2

Source topic: `buttons.md`

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

## Destructive buttons — example 3

Source topic: `buttons.md`

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

## Prefer semantic tokens — example 1

Source topic: `colors-themes.md`

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

## Light and dark mode — example 2

Source topic: `colors-themes.md`

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

## One visual system for single-line controls — example 1

Source topic: `forms.md`

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

## Canonical single-line input — example 2

Source topic: `forms.md`

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

## Selects must match inputs — example 3

Source topic: `forms.md`

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
