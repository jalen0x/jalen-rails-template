# RTL Layout Guide for Jumpstart Pro Rails

When adding an RTL locale (Arabic, Hebrew, Farsi, Urdu), all view files must be converted from physical CSS direction classes to logical properties. This ensures layouts automatically mirror for RTL languages.

## Helper Infrastructure

Add these to `app/helpers/language_helper.rb`:

```ruby
RTL_LOCALES = %i[ar he fa ur].freeze

def rtl?
  RTL_LOCALES.include?(I18n.locale.to_s.split("-").first.to_sym)
end

def text_dir
  rtl? ? "rtl" : "ltr"
end
```

Set the `dir` attribute on the `<html>` tag in `app/views/layouts/application.html.erb`:

```erb
<html dir="<%= text_dir %>" lang="<%= I18n.locale %>">
```

## CSS Class Conversion Table

Tailwind CSS v4 logical properties. Replace every occurrence in `app/views/`:

| Physical (LTR-only) | Logical (LTR+RTL) | CSS Property |
|---------------------|-------------------|--------------|
| `ml-*` | `ms-*` | margin-inline-start |
| `mr-*` | `me-*` | margin-inline-end |
| `pl-*` | `ps-*` | padding-inline-start |
| `pr-*` | `pe-*` | padding-inline-end |
| `left-*` | `start-*` | inset-inline-start |
| `right-*` | `end-*` | inset-inline-end |
| `text-left` | `text-start` | text-align: start |
| `text-right` | `text-end` | text-align: end |
| `border-l-*` | `border-s-*` | border-inline-start |
| `border-r-*` | `border-e-*` | border-inline-end |
| `rounded-l-*` | `rounded-s-*` | border-start-radius |
| `rounded-r-*` | `rounded-e-*` | border-end-radius |
| `scroll-ml-*` | `scroll-ms-*` | scroll-margin-inline-start |
| `scroll-mr-*` | `scroll-me-*` | scroll-margin-inline-end |

## Exceptions — Keep Physical

These classes should NOT be converted:

### Progress Bars
```erb
<%# left-0 positions the fill bar visually — always starts from left %>
<div class="absolute top-0 left-0 h-full bg-green-500"></div>
```

### Gradients
```erb
<%# bg-gradient-to-r is visual direction, not text direction %>
<div class="bg-gradient-to-r from-green-500 to-emerald-500">
```

### Decorative Animations
```erb
<%# Absolute-positioned decorative elements — visual, not layout %>
<div class="absolute bottom-1/4 right-1/4 w-96 h-96 animate-pulse">
```

### Flowbite JS API Parameters
```erb
<%# data-dropdown-placement is a JS API string, not a CSS class %>
<div data-dropdown-placement="right-start">
```

### SVG Path Coordinates
```erb
<%# SVG path d="" values contain directional drawing commands — never change %>
<path d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
```

## Sidebar RTL Pattern

Off-canvas sidebars that slide in from the left need explicit RTL handling. The sidebar uses `-translate-x-full` to hide (slide left), but in RTL it must slide right instead:

```erb
<aside class="fixed start-0 top-0 z-40 h-screen w-56
              -translate-x-full lg:translate-x-0
              rtl:translate-x-full rtl:lg:translate-x-0
              border-e border-default">
```

Key changes:
- `left-0` → `start-0` (position follows text direction)
- `border-r` → `border-e` (border follows text direction)
- Add `rtl:translate-x-full rtl:lg:translate-x-0` (mirror the slide animation)

## Common View Files to Check

These files typically contain physical direction classes in a Jumpstart Pro app:

### Layout & Navigation
- `app/views/layouts/application.html.erb` — `dir` attribute
- `app/views/application/_sidebar.html.erb` — sidebar positioning, borders, icons
- `app/views/application/_flash.html.erb` — toast positioning
- `app/views/application/_audio_player.html.erb` — player bar positioning
- `app/views/application/_locale_selector_bar.html.erb` — bar positioning

### Editor
- `app/views/editors/_*.html.erb` — form fields, icons, tag suggestions

### Content Pages
- `app/views/public/index.html.erb` — hero, features, testimonials, footer
- `app/views/public/ai_background_music_generator.html.erb` — landing page
- `app/views/pricing/show.html.erb` — pricing toggle
- `app/views/dashboard/show.html.erb` — dashboard layout

### Account & Billing
- `app/views/accounts/show.html.erb` — settings forms, text alignment
- `app/views/billing/_charges.html.erb` — table alignment
- `app/views/billing/subscriptions/_plan.html.erb` — plan cards

### Blog & Legal
- `app/views/blog_posts/index.html.erb` — article list
- `app/views/blog_posts/show.html.erb` — article detail, back link
- `app/views/users/agreements/_*.html.erb` — back link icons

### Songs
- `app/views/songs/_song.html.erb` — song card layout, action buttons

## Verification

Run these grep commands to find remaining physical direction classes:

```bash
# Find all physical direction classes in views
grep -rn --include="*.erb" -E '\b(ml-|mr-|pl-|pr-)[0-9]' app/views/
grep -rn --include="*.erb" -E '\b(text-left|text-right)\b' app/views/
grep -rn --include="*.erb" -E '\b(border-l|border-r)-' app/views/
grep -rn --include="*.erb" -E '\bleft-[0-9]' app/views/
grep -rn --include="*.erb" -E '\bright-[0-9]' app/views/
```

Review each match — some are legitimate exceptions (see above). The goal is zero non-exception physical direction classes.

## Gotchas from Real Implementation

1. **Responsive variants follow the same pattern**: `sm:text-right` → `sm:text-end`, `lg:pr-0` → `lg:pe-0`, `lg:left-56` → `lg:start-56`

2. **ERB `class:` vs HTML `class=`**: When editing `link_to` helpers, the class attribute uses Ruby hash syntax (`class: "..."`) not HTML attribute syntax (`class="..."`). Match exactly or the edit will fail.

3. **SVG icon spacing**: Icons inside buttons/links use `me-2` (margin-end) to separate from text. This is the most common conversion — search for `mr-1`, `mr-2`, `mr-3` in SVG icon containers.

4. **Table alignment**: Tables with `text-left` headers/cells should become `text-start`. Check billing and account settings pages.

5. **Dropdown positioning**: Flowbite dropdowns with `left-0` positioning should become `start-0`, but `data-dropdown-placement` values stay as-is (they're JS API strings).

6. **`replace_all: true` safety**: Only use for identical repeated patterns (e.g., 4 identical TL;DR list items with `mr-2`). For unique strings, always use targeted replacement.

7. **Turbo Drive blocks `<html>` attribute updates**: Turbo Drive only replaces `<body>` content — `<html dir="...">` is NOT updated on Turbo navigation. All locale-switching links MUST have `data-turbo="false"` (or `data: { turbo: false }` in Rails helpers) to force a full page reload. Without this, switching between RTL and LTR languages won't change the layout direction until the user manually refreshes.

   ```erb
   <%# WRONG — Turbo intercepts, dir attribute stays stale %>
   <%= link_to url_for(locale: locale.to_s), class: "..." do %>

   <%# CORRECT — full page reload updates <html dir="..."> %>
   <%= link_to url_for(locale: locale.to_s), data: { turbo: false }, class: "..." do %>
   ```

   Check ALL locale-switching links: sidebar language dropdown (signed-in and signed-out), locale selector bar, and any other language switcher UI.
