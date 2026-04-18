# Design System Inspiration of Flowbite Admin Dashboard

## 1. Visual Theme & Atmosphere

Flowbite Admin Dashboard is a utilitarian, information-dense admin surface built on Tailwind CSS v4 with the Flowbite component plugin. Its visual language is intentionally unopinionated: a neutral gray ramp does almost all of the structural work, punctuated by a single saturated blue accent (`#1d4ed8` / primary-700) that carries every interactive signal — primary buttons, focus rings, link text, chart series. The aesthetic is closer to Stripe's dashboard or GitHub's settings pages than to a marketing site; it is not trying to be distinctive, it is trying to get out of the way of the data.

Light mode is the default visual target (pages default to `bg-gray-50` / `dark:bg-gray-900`), but every component is dark-mode-paired via the `dark:` variant, using the `class` strategy (`@custom-variant dark (&:where(.dark, .dark *))`). The base HTML element ships with `class="dark"` in this template, so dark mode is the out-of-the-box look, but swapping to light is a single class change — both modes are first-class. Dark mode desaturates to blue-gray slates (`gray-700` `#374151` for inputs, `gray-800` `#1f2937` for panels, `gray-900` `#111827` for the page), never pure black. The result is a surface that feels engineered rather than moody.

Typography is Inter throughout — `cv01, ss03` are NOT enabled (this is stock Inter, not Linear's tuned variant). Headings rely on weight jumps (400 → 600 → 700) rather than aggressive letter-spacing; sizes follow Tailwind's default scale (`text-sm` 14px / `text-base` 16px / `text-lg` 18px / `text-xl` 20px / `text-2xl` 24px / `text-3xl` 30px). The system leans on `font-semibold` (600) and `font-bold` (700) heavily to create hierarchy without varying the typeface.

The geometry is soft-rounded and generously spaced. `rounded-lg` (8px) is the dominant radius — every card, button, input, dropdown, and modal uses it. Cards sit on a single `shadow-sm` with internal padding `p-4 md:p-6`, arranged on a 1rem (`gap-4`) grid. There is no glass morphism, no gradients in chrome, no decorative shadows — shadows exist only to lift dropdowns (`shadow-md`) and tooltips (`shadow-xs`) above the flow.

**Key Characteristics:**
- Dual-mode by default: every component has matched light/dark variants via Tailwind's `dark:` prefix (class strategy)
- Default page: `bg-gray-50` (light) / `bg-gray-900` (dark) — never pure white, never pure black
- Primary brand: Tailwind `blue-*` ramp aliased as `primary-*` — primary-700 (`#1d4ed8`) for CTAs, primary-500 (`#3b82f6`) for focus rings
- Gray ramp does the heavy lifting: gray-200 borders, gray-500 secondary text, gray-700/800/900 surfaces in dark mode
- Inter font with stock OpenType settings (no `cv01`/`ss03`); hierarchy via weight jumps, not letter-spacing
- `rounded-lg` (8px) is the default radius for virtually every container
- `shadow-sm` on cards, `shadow-md` on dropdowns/menus, `shadow-xs` on tooltips; otherwise flat
- 1rem (`p-4`) mobile padding, 1.5rem (`md:p-6`) desktop padding on content containers
- Fixed 4rem (`h-16`) top navbar; fixed sidebar ≥`lg:` breakpoint
- Status colors come from Tailwind's full palette — green, red, yellow, purple, indigo, pink, teal, orange — each paired with its own 50/700/900/300 quartet for badges and indicators
- Every focus state uses a 4px colored ring: `focus:ring-4 focus:ring-primary-300` (light), `focus:ring-primary-800` (dark)

## 2. Color Palette & Roles

### Brand Primary (Tailwind `blue` aliased to `primary`)
Defined in `src/app.css` under `@theme`:

- **primary-50** `#eff6ff` — badge/pill backgrounds, hover-tint on light surfaces
- **primary-100** `#dbeafe` — hover on primary-50
- **primary-200** `#bfdbfe`
- **primary-300** `#93c5fd` — focus ring (light mode)
- **primary-400** `#60a5fa`
- **primary-500** `#3b82f6` — input focus border, dark-mode link text
- **primary-600** `#2563eb` — dark-mode CTA background
- **primary-700** `#1d4ed8` — **default CTA background, link text, brand accent**
- **primary-800** `#1e40af` — CTA hover, focus ring (dark mode)
- **primary-900** `#1e3a8a` — badge background in dark mode

### Neutral Gray (Tailwind default)
- **gray-50** `#f9fafb` — page background (light mode), subtle hover tint
- **gray-100** `#f3f4f6` — hover state on light surfaces
- **gray-200** `#e5e7eb` — default border (light), divider
- **gray-300** `#d1d5db` — input border (light)
- **gray-400** `#9ca3af` — secondary text (dark mode), placeholder
- **gray-500** `#6b7280` — **secondary text (light), muted labels**
- **gray-600** `#4b5563` — input border (dark), divider (dark)
- **gray-700** `#374151` — input background (dark), hover surface (dark)
- **gray-800** `#1f2937` — **panel background (dark)**, card surface (dark)
- **gray-900** `#111827` — **page background (dark)**, primary text (light)

### Status Colors (each used with 50 / 700 / 900 / 300 quartet)
Used for pills, event tags, status indicators, chart series:

| Color | Light bg / text | Dark bg / text | Usage |
|-------|----------------|----------------|-------|
| Green | `green-50` / `green-700` | `green-900` / `green-300` | Success, positive delta, active |
| Red | `red-50` / `red-700` | `red-900` / `red-300` | Error, destructive, negative delta |
| Yellow | `yellow-50` / `yellow-700` | `yellow-900` / `yellow-300` | Warning, pending |
| Purple | `purple-50` / `purple-700` | `purple-900` / `purple-300` | Category/label |
| Indigo | `indigo-50` / `indigo-700` | `indigo-900` / `indigo-300` | Category/label |
| Pink | `pink-50` / `pink-700` | `pink-900` / `pink-300` | Category/label |
| Teal | `teal-50` / `teal-700` | `teal-900` / `teal-300` | Category/label |
| Orange | `orange-50` / `orange-700` | `orange-900` / `orange-300` | Category/label |

Chart series typically combine primary-500 + green-500 + one or two category colors.

### Semantic Role Mapping

| Role | Light mode | Dark mode |
|------|-----------|-----------|
| Page background | `bg-gray-50` | `bg-gray-900` |
| Card / panel surface | `bg-white` | `bg-gray-800` |
| Elevated surface (dropdown, modal) | `bg-white` | `bg-gray-700` |
| Sticky navbar | `bg-white border-gray-200` | `bg-gray-800 border-gray-700` |
| Primary text | `text-gray-900` | `text-white` |
| Secondary text | `text-gray-500` | `text-gray-400` |
| Muted / metadata | `text-gray-400` | `text-gray-500` |
| Default border | `border-gray-200` | `border-gray-700` |
| Input border | `border-gray-300` | `border-gray-600` |
| Input background | `bg-gray-50` | `bg-gray-700` |
| Placeholder | `placeholder-gray-400` (default) | `dark:placeholder-gray-400` |
| Hover tint | `hover:bg-gray-100` | `dark:hover:bg-gray-700` |
| Divider | `divide-gray-100` / `divide-gray-200` | `dark:divide-gray-600` / `dark:divide-gray-700` |

## 3. Typography Rules

### Font Family
Defined in `src/app.css`:

- **Sans / Body**: `'Inter', ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'`
- **Mono**: `ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace`
- **OpenType features**: none enabled globally — stock Inter rendering
- Body uses `antialiased` on the `<body>` element

### Weights in Use
- **400** (regular) — body copy, input text
- **500** (medium) — navigation links, button labels, tab labels
- **600** (semibold) — card titles, H3, emphasized body, table headers
- **700** (bold) — large metric numbers, H1/H2 display

### Hierarchy (Tailwind utility → semantic role)

| Role | Tailwind classes | Size / weight / leading | Notes |
|------|------------------|--------------------------|-------|
| Metric display XL | `text-3xl font-bold leading-none` | 30px / 700 / 1.0 | Hero numbers on dashboard cards (`sm:text-3xl`) |
| Metric display | `text-2xl font-bold leading-none` | 24px / 700 / 1.0 | Primary KPIs in cards |
| Page title | `text-2xl font-semibold` | 24px / 600 / ~1.33 | Dashboard section H2 |
| Card title | `text-xl font-bold` or `text-xl font-semibold` | 20px / 700 or 600 | Widget/card headers |
| Subsection | `text-lg font-semibold` | 18px / 600 / ~1.55 | Toolbar titles, modal titles |
| Body default | `text-base` | 16px / 400 / 1.5 | Rich content |
| UI default | `text-sm font-medium` | 14px / 500 / ~1.43 | Buttons, navigation, table cells |
| Table / metadata body | `text-sm` | 14px / 400 | Table data, descriptions |
| Caption / small | `text-xs font-medium` | 12px / 500 | Badges, pill labels, timestamps |
| Uppercase eyebrow | `text-xs font-semibold uppercase` | 12px / 600 + uppercase | Report-link CTAs, section labels |

Links follow the primary color ramp: `text-primary-700 hover:underline` in light mode, `dark:text-primary-500 dark:hover:text-primary-600` in dark mode.

## 4. Layout & Spacing

### Breakpoints (Tailwind default)
- `sm` 640px / `md` 768px / `lg` 1024px / `xl` 1280px / `2xl` 1536px

### App Shell
- **Top navbar**: fixed, `h-16` (4rem / 64px), full width, z-index `z-10`. Contains: logo, search (lg+), notifications/avatar dropdowns. `bg-white border-b border-gray-200` / `dark:bg-gray-800 dark:border-gray-700`
- **Sidebar**: fixed under navbar at `lg:` breakpoint, ~16rem wide (`w-64`). Collapsible via `data-drawer-*` API on mobile, toggle-collapsible on desktop. Same background as navbar.
- **Main content**: offset `lg:ml-64` (or equivalent), vertical padding `pt-4` below navbar. Content wrapper uses `px-4` mobile, wider paddings for unconstrained layouts.

### Grid & Cards
- Dashboard grids: `grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3` (or `xl:grid-cols-4` for 4-up KPIs)
- Gap: `gap-4` (1rem) — consistent across all card grids
- Card container: `rounded-lg bg-white p-4 shadow-sm dark:bg-gray-800 md:p-6`
- Card vertical rhythm: `space-y-4 md:space-y-6` between internal sections
- Card footer: separated by `border-t border-gray-200 dark:border-gray-700 pt-4 sm:pt-6`

### Spacing Scale (used in practice)
- Micro: `space-x-1`, `space-y-1` (4px) — icon-to-label gutters
- Small: `space-x-2` / `p-2` (8px) — inline clusters
- Medium: `p-3`, `py-2.5`, `gap-3` (10–12px) — default form/control padding
- Default: `p-4`, `gap-4` (16px) — card padding (mobile), grid gutters
- Large: `p-6`, `gap-6` (24px) — card padding (desktop), section spacing
- XL: `p-8` (32px) — page containers, auth forms

### Z-Index Layers
- `z-10` — sticky navbar/sidebar
- `z-50` — dropdowns, popovers
- Overlays/modals via Flowbite's backdrop layer

## 5. Border, Radius & Shadow

### Radius (almost exclusively `rounded-lg`)
- `rounded-sm` (2px) — occasional icon buttons, sidebar toggle hitbox
- `rounded-md` (6px) — dropdown menu items, secondary pills
- **`rounded-lg` (8px) — DEFAULT — cards, primary/secondary buttons, inputs, dropdowns, modals, tooltips, popovers, chart event pills, search box**
- `rounded-full` — avatars, circular status dots, tag removers

### Borders
- Width: `border` (1px) is universal; `border-2` only for strong emphasis
- Default light border: `border-gray-200`; dark: `dark:border-gray-700`
- Input border: `border-gray-300` / `dark:border-gray-600` (one step darker than structural)
- Dividers in lists: `divide-y divide-gray-100 dark:divide-gray-600`
- Focus borders: `focus:border-primary-500 dark:focus:border-primary-500`

### Shadows
- **`shadow-sm`** — every card, every widget (the default elevation)
- **`shadow-md`** — notification dropdowns, account menus, anything that pops out of flow
- **`shadow-xs`** — tooltips, micro-popovers (very subtle)
- **`shadow-lg`** — map tooltips, on-map callouts
- No custom multi-layer shadows; no inset shadows; no glow effects

### Focus Rings
Universal pattern — always 4px colored ring, color matches control type:

- Primary action: `focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-800`
- Secondary/neutral: `focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700`
- Small icon buttons: `focus:ring-2 focus:ring-gray-300 dark:focus:ring-gray-600`

## 6. Component Patterns

### Primary Button
```
inline-flex items-center justify-center
rounded-lg bg-primary-700 px-3 py-2
text-sm font-medium text-white
hover:bg-primary-800
focus:outline-none focus:ring-4 focus:ring-primary-300
dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800
```

### Secondary / Neutral Button
```
inline-flex items-center justify-center
rounded-lg border border-gray-200 bg-white px-4 py-2
text-sm font-medium text-gray-900
hover:bg-gray-100 hover:text-primary-700
focus:z-10 focus:outline-none focus:ring-4 focus:ring-gray-100
dark:border-gray-600 dark:bg-gray-800 dark:text-gray-400
dark:hover:bg-gray-700 dark:hover:text-white dark:focus:ring-gray-700
```

### Icon-Only Button
```
rounded-lg p-1.5 text-gray-500
hover:bg-gray-100 hover:text-gray-900
focus:ring-2 focus:ring-gray-300
dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white dark:focus:ring-gray-600
```

### Text Input
```
block w-full rounded-lg border border-gray-300 bg-gray-50 p-2.5
text-sm text-gray-900
focus:border-primary-500 focus:ring-primary-500
dark:border-gray-600 dark:bg-gray-700 dark:text-white
dark:placeholder-gray-400 dark:focus:border-primary-500 dark:focus:ring-primary-500
```
Height: `p-2.5` (10px) or `p-2 ps-9` (with leading icon). Search inputs use `pl-9` to accommodate a 16px search icon at `left-0 pl-3`.

### Card
```
rounded-lg bg-white p-4 shadow-sm dark:bg-gray-800 md:p-6
```
With internal structure — header row `flex items-start justify-between`, metric block (`text-2xl font-bold text-gray-900 dark:text-white`), supporting label (`text-gray-500 dark:text-gray-400`), optional footer divider.

### Delta / Trend Pill (inline, used in card headers)
```
flex items-center font-semibold text-green-500 dark:text-green-400
```
Paired with a small up/down arrow SVG. For negative deltas swap `text-green-500` → `text-red-500`.

### Badge / Status Pill
```
rounded-md bg-{color}-100 px-2 py-0.5 text-xs font-medium text-{color}-800
dark:bg-{color}-900 dark:text-{color}-300
```
Any status color (primary/green/red/yellow/purple/indigo/pink/teal/orange) works.

### Dropdown / Menu
Container:
```
z-50 my-4 hidden w-40 list-none divide-y divide-gray-100 rounded-lg
bg-white text-sm font-medium shadow-sm
dark:divide-gray-600 dark:bg-gray-700
```
Menu item:
```
inline-flex w-full items-center rounded-md px-3 py-2
hover:bg-gray-100 hover:text-gray-900
dark:hover:bg-gray-600 dark:hover:text-white
```

### Tooltip / Popover
```
invisible absolute z-10 inline-block rounded-lg border border-gray-200
bg-white text-sm text-gray-500 opacity-0 shadow-xs transition-opacity duration-300
dark:border-gray-600 dark:bg-gray-800 dark:text-gray-400
```

### Table
- Container: `overflow-x-auto` wrapper around `<table class="w-full text-left text-sm text-gray-500 dark:text-gray-400">`
- Header: `<thead class="bg-gray-50 text-xs uppercase text-gray-700 dark:bg-gray-700 dark:text-gray-400">`; cells `px-4 py-3`
- Row: `border-b border-gray-200 hover:bg-gray-100 dark:border-gray-700 dark:hover:bg-gray-700`
- Row cells: `px-4 py-3`; primary column often uses `font-medium text-gray-900 dark:text-white`

### Link
- Inline: `font-medium text-primary-600 hover:text-primary-700 hover:underline dark:text-primary-500 dark:hover:text-primary-600`
- Navigation: typically just `text-sm font-medium` with hover color swap; no underline

### Navbar Logo Lockup
```
<a href="/" class="mr-4 flex">
  <img src="/logo.svg" class="mr-3 h-8" alt="Brand" />
  <span class="self-center whitespace-nowrap text-2xl font-semibold dark:text-white">Brand</span>
</a>
```
Logo 32px tall, aligned optically center with wordmark in `text-2xl font-semibold`.

### Chart Event / Calendar Pill
```
rounded-lg border-0 bg-primary-50 p-2 text-sm font-medium text-primary-700
hover:bg-primary-100
dark:bg-primary-900 dark:text-primary-300 dark:hover:bg-primary-800
```
Each event starts with a small colored dot (`h-2 w-2 rounded-full bg-primary-700 dark:bg-primary-300`) before the label. The pattern repeats for purple/indigo/pink/teal/green/yellow/orange/red event types — same shape, different color ramp.

## 7. Iconography

- Inline SVG throughout — no icon-font dependency, no separate icon library. Flowbite's own icon set is used, consistent with [flowbite.com/icons](https://flowbite.com/icons/).
- Standard sizes: `h-4 w-4` (16px) for inline icons, `h-5 w-5` (20px) for emphasis, `h-6 w-6` (24px) for navbar actions, `h-7 w-7` (28px) for sidebar toggle
- Stroke icons: `stroke="currentColor" stroke-linecap="round" stroke-width="2"` — icons inherit text color
- Filled icons: `fill="currentColor"` — same inheritance
- Icon color tracks text: `text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white`
- Spacing to label: `me-1.5` (6px) before text, `ms-1.5` (6px) after — uses logical properties (`me-*` / `ms-*`) for RTL compatibility

## 8. Dark Mode Strategy

- Variant: `class` strategy via `@custom-variant dark (&:where(.dark, .dark *))` in `app.css`
- Toggle: add/remove `class="dark"` on `<html>`. Script handles persistence via `localStorage` + OS `prefers-color-scheme`
- Every component ships with paired `dark:` utilities — there is no separate dark stylesheet
- Color inversions follow a strict rule:
  - `bg-white` → `dark:bg-gray-800`
  - `bg-gray-50` → `dark:bg-gray-900`
  - `bg-gray-100` (hover) → `dark:bg-gray-700` (hover)
  - `text-gray-900` → `dark:text-white`
  - `text-gray-500` → `dark:text-gray-400`
  - `border-gray-200` → `dark:border-gray-700`
  - `border-gray-300` → `dark:border-gray-600`
  - Primary: light mode uses `primary-700`, dark mode uses `primary-600` (one step lighter, because darker surfaces need brighter accents)

## 9. RTL & Internationalization

- Uses Tailwind logical properties throughout: `ps-*` / `pe-*` (padding-inline-start/end), `ms-*` / `me-*` (margin), `start-0` / `end-0`
- SVGs that point directionally (arrow links) add `rtl:rotate-180`

## 10. Accessibility Patterns

- Every interactive element has a visible focus ring (4px, colored — see Section 5)
- Icon-only buttons always include a `<span class="sr-only">Label</span>`
- Dropdowns use `aria-expanded`, `aria-controls`, `aria-labelledby` (managed by Flowbite's `data-dropdown-toggle` API)
- Tooltips use `role="tooltip"` with `data-popover` + `data-popover-target` linkage
- Color contrast: primary text (`gray-900` on `gray-50`, `white` on `gray-900`) passes AAA; secondary text (`gray-500` on `gray-50`) passes AA
- Form inputs always carry a `<label>` — often visually `sr-only` when the UI uses a placeholder/icon as the visible cue

## 11. Motion

Motion is minimal and purposeful:

- `transition-opacity duration-300` on tooltips/popovers (fade in/out)
- Default Tailwind `transition` (150ms) on hover color changes — not explicitly declared on most elements, inherited from user-agent defaults
- Sidebar drawer uses Flowbite's `transform translate-x-*` with `transition-transform` when sliding in on mobile
- No scroll-linked animations, no hero animations, no entrance choreography — this is a workspace, not a showcase

## 12. Implementation Notes

### Stack
- **Tailwind CSS v4** (`@import "tailwindcss"`) — using the new `@theme` / `@plugin` / `@source` / `@custom-variant` at-rules
- **Flowbite plugin** (`@plugin "flowbite/plugin"`) — provides component JS (dropdowns, modals, drawers, datepickers, tooltips)
- **Flowbite Typography** (`@plugin "flowbite-typography"`) — for prose content
- **Inter font** loaded from local or CDN
- **ApexCharts** for charts, **FullCalendar** for calendar, **SortableJS** for kanban drag-and-drop

### File Organization
- `src/app.css` — Tailwind theme tokens, Flowbite imports, component overrides (calendar, map, kanban)
- `src/app.js` — entry point, imports feature scripts
- `src/{feature}.js` — per-feature behavior (charts, calendar, sidebar, kanban, chat, video-call, wysiwyg)
- `layouts/partials/*.html` — shared navbar/sidebar/footer partials (Hugo templates)
- `content/**/*.html` — page content

### Extending the Palette
To re-skin to a different accent color (e.g. emerald, violet), override the `primary-*` ramp in `@theme` — because all Flowbite components reference `primary-*` (not the underlying `blue-*`), a single block change updates every button, link, focus ring, and badge.

### Usage Instruction for AI Agents
When generating UI in this project or a project adopting this template:

1. **Use the `primary-*` ramp for all brand/accent usage**, never hardcode `blue-*` or hex values.
2. **Every surface, text color, and border must ship a `dark:` counterpart.** If you can't decide, consult Section 2's Semantic Role Mapping table.
3. **Default to `rounded-lg` for any boxed element.** Deviate only for avatars (`rounded-full`) and small toggles (`rounded-sm`).
4. **Default shadow is `shadow-sm` on cards, `shadow-md` on floating menus.** Do not invent new shadow utilities.
5. **Use Flowbite's `data-*` APIs** (`data-dropdown-toggle`, `data-modal-target`, `data-drawer-toggle`, `data-popover-target`, `data-tooltip-target`) rather than hand-rolling open/close JavaScript.
6. **Follow the button / input / card class strings in Section 6 verbatim** — they are the canonical forms and already pass the project's visual review.
7. **Use inline SVG with `currentColor`** for icons; do not add icon-font or component-library dependencies.
