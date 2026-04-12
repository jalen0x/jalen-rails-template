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

## Semantic HTML Before Layout

1. First, mark up all content and controls with correct semantic tags (`<article>`, `<section>`, `<nav>`, `<ul>`, `<h2>`) — ignore styling.
2. **Then** add `<div>`/`<span>` for layout and styling purposes.

Even when redesigning the UI, `<ul>` is still `<ul>` — semantic structure is stable. `<div>` / `<span>` exist purely for visual presentation.

## Partials & Strict Locals (Rails 7.1+)

Declare at the top of the partial:

```erb
<%# locals: (widget:, show_cta: true) %>
```

Missing or misspelled locals raise immediately instead of silently returning nil. Partials **may only reference declared locals** — never touch `@instance_variables`.

## Active Model Instead of Presenter/Decorator

When a view needs "Widget + extra behavior" (`local_to_user?`, `display_name`, etc.), don't create `WidgetPresenter` or `WidgetDecorator`. Two problems:
- Variable naming confusion (`@widget` or `@widget_presenter`?)
- Partials don't know which type to expect

Correct approach: build a view-specific resource class with `include ActiveModel::Model` (implement `persisted?` and `to_key` so Rails routing/form helpers work seamlessly). View code stays unchanged.

## Sorting Belongs in the View

```erb
<%= options_from_collection_for_select(@manufacturers.sort_by(&:name), :id, :name) %>
```

"Making data consumable for the user" is a view concern — the controller provides raw data.

## Fake Errors for Styling

Before backend validation logic is complete, manually inject errors to style the error states:

```ruby
def new
  @widget = Widget.new
  @widget.errors.add(:name, :blank)
  @widget.errors.add(:price_cents, :not_a_number)
end
```

Avoids debugging frontend and backend simultaneously. Remove the temporary code after styling is done.

## Helpers

- Helpers do only two things: (1) expose global UI state (`current_user`, feature flags), (2) generate inline markup too small to justify a partial or View Component.
- **Never build HTML via string interpolation** (XSS risk) — always use `content_tag`, `tag.div`, etc. If you must use `html_safe`, add a comment explaining why it's safe.
- Concepts users "speak, write down, or pass around in emails" (e.g. item ID `1234-567`) are **domain concepts** — put them in model methods, not helpers. Once in a helper, they get copy-pasted across the codebase.

Mailer rules are in the separate `mailers.md`.
