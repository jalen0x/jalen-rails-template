---
paths:
  - "app/assets/stylesheets/**/*.css"
  - "app/views/**/*.erb"
  - "app/components/**/*.erb"
  - "app/javascript/**/*.js"
---

# Tailwind CSS v4

## Config

- CSS-first: use the `@theme` directive, not `tailwind.config.js`.
- Import: `@import "tailwindcss"` (not `@tailwind` directives).
- PostCSS plugin: `@tailwindcss/postcss`.
- Plugins via `@plugin "@tailwindcss/typography"`.

## Breaking Changes from v3

- `shadow-sm` → `shadow-xs`, `shadow` → `shadow-sm`
- `rounded-sm` → `rounded-xs`, `rounded` → `rounded-sm`
- `blur-sm` → `blur-xs`, `blur` → `blur-sm`
- `outline-none` → `outline-hidden`
- `bg-opacity-*` removed → use `bg-black/50`
- Default border color is `currentColor` (was `gray-200`)
- Default ring width is 1px (was 3px)
- CSS variables: `bg-(--brand-color)` not `bg-[--brand-color]`
- Gradient: `bg-linear-45` (renamed from `bg-gradient-*`)

## Component CSS Files (`layer(components)`)

Never use `@apply` in files imported with `layer(components)`. Use CSS variables instead:

```css
/* Do */
background-color: var(--color-neutral-secondary-medium);
border-radius: var(--radius-base);

/* Don't */
@apply bg-neutral-secondary-medium rounded-base;
```

## RTL

Use logical properties: `ms-*` / `me-*` not `ml-*` / `mr-*`, `ps-*` / `pe-*` not `pl-*` / `pr-*`.

## UI Color Classes (Flowbite 4 Semantic)

Never use hardcoded Tailwind colors (`gray-*`, `blue-*`, `primary-*`) or `dark:` overrides. Reference: `node_modules/flowbite/src/themes/default.css`.

```erb
<%# Links %>
class="font-medium text-fg-brand hover:underline"

<%# Primary buttons %>
class="text-white bg-brand box-border border border-transparent hover:bg-brand-strong focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Secondary buttons %>
class="text-body bg-neutral-secondary-medium box-border border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Danger buttons (outline) %>
class="text-danger bg-neutral-primary border border-danger hover:bg-danger hover:text-white focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Form inputs %>
class="bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full px-3 py-2.5 shadow-xs placeholder:text-body"

<%# Cards/containers %>
class="bg-neutral-primary-soft border border-default rounded-base shadow-xs"

<%# Checkbox %>
<div class="flex items-center">
  <input type="checkbox" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
  <label class="select-none ms-2 text-sm font-medium text-heading">Label</label>
</div>
```

Keep `text-white` on brand/danger backgrounds. Keep `after:bg-white` in toggle switches.

Before re-typing these class strings in a view, check whether `ButtonComponent`, `FormField::InputComponent`, `FormField::CheckboxComponent`, `FlashComponent`, or `ModalComponent` already does what you need.

## Typography

- `text-balance` for headings, `text-pretty` for body paragraphs.
- `tabular-nums` for numeric data in tables.
- `truncate` or `line-clamp-*` for dense UI.
- Never modify `letter-spacing` (`tracking-*`) unless explicitly requested.

## Animation

- Never add animation unless explicitly requested.
- Use CSS `transition-*` utilities, not JavaScript animation.
- Animate only `transform` and `opacity` — never large `blur()` or `backdrop-filter`.
- `ease-out` for entrance, `ease-in` for exit, max `200ms` for interaction feedback.
- Respect `prefers-reduced-motion` with the `motion-reduce:` prefix.

## Layout

- Fixed z-index scale: 10, 20, 30, 40, 50 — no arbitrary `z-*` values.
- Use `size-*` for square elements instead of `w-*` + `h-*`.
- Respect `safe-area-inset` for fixed/sticky elements on mobile.
- Never use fixed pixel widths for containers — use `max-w-*` or `container`.

## Performance

- Never apply `will-change` outside an active animation.
- Lazy-load images below the fold with `loading="lazy"`.

## Design

- Never use gradients or glow effects unless explicitly requested.
- Use the Tailwind default shadow scale.
- Limit accent color to one per view.
