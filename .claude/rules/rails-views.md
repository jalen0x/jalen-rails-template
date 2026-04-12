---
paths:
  - "app/views/**/*.html.erb"
  - "app/components/**/*.html.erb"
---

# Rails View Standards

- Prefer server-side rendering over client-side JS for UI state.
- Use `content_for :title` for page titles.
- Use `dom_id` for HTML element IDs.
- Use partials for reusable snippets — always pass strict locals, never reference `@instance_variables` in partials (causes coupling, breaks caching, prevents reuse).
- Use `render @collection` for collections — not manual loops.
- Make all views responsive with breakpoints (`sm:`, `md:`, `lg:`, `xl:`).
- Use semantic HTML elements (`nav`, `main`, `article`, `section`, `aside`).
- Add `aria-label` to icon-only buttons, ensure keyboard navigation works.
- Use inline SVG for icons — never icon fonts.
- Show form errors inline next to the field.
- Use a Flowbite modal for destructive confirmation dialogs.
- Give empty states one clear call-to-action.
- Never block paste in `input` or `textarea` elements.
- `data-turbo-permanent` requires a unique `id` attribute — without it Turbo Drive cannot match and persist the element across navigations. Exception: morphing mode uses it as a "skip morph" marker without `id`.

## Components vs Partials

- Reusable UI with behavior, variants, or slots → `app/components/*_component.{rb,html.erb}` (ViewComponent). Add a preview under `test/components/previews/` so `/lookbook` stays complete.
- Layout carve-outs (`_head`, `_nav`, etc.) → plain partials under `app/views/application/`.
- Prefer extending an existing component (e.g. `ButtonComponent`, `FormField::InputComponent`) over re-typing Tailwind/Flowbite class strings. Copy-pasting class lists twice is a smell.

## Forms

- `autofocus: true` on the first input for new records.
- Mark required fields with `*`.
- Use HTML5 validation.
- Use `f.button ..., type: :submit` instead of `f.submit`.
- Add `data: { turbo_submits_with: "Saving..." }` for loading state.

## JavaScript Files

- `app/javascript/controllers/` holds only Stimulus controller files.
- Non-controller JS goes in `app/javascript/src/`.

Color classes and button styles: see `tailwind-v4.md` → "UI Color Classes".
