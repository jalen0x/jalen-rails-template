---
name: flowbite
description: "Flowbite UI component library reference. Use when writing HTML/Tailwind for Flowbite components, forms, typography, plugins, or customizing theme/dark mode/colors/RTL. Triggers: flowbite, accordion, alert, avatar, badge, banner, breadcrumb, button, card, carousel, chat-bubble, clipboard, datepicker, drawer, dropdown, footer, gallery, indicator, jumbotron, kbd, list-group, mega-menu, modal, navbar, pagination, popover, progress, rating, sidebar, skeleton, speed-dial, spinner, stepper, table, tabs, timeline, toast, tooltip, typography, video, input, textarea, checkbox, radio, toggle, range, select, chart, datatable, wysiwyg"
---

# Flowbite

Flowbite is a free and open-source UI component library built on top of Tailwind CSS. It provides ready-to-use HTML components with data attributes to enable interactive elements.

**Usage**: When implementing a component, read the matching reference file below. All references are plain markdown with HTML code blocks.

## Project constraints

- **Custom JS**: write a Stimulus controller in `app/javascript/controllers/`. No inline `<script>` tags.
- **Modals**: open a modal by putting `data: { turbo_frame: "modal_content" }` on the TRIGGERING link (from a normal page). The target view wraps in `turbo_frame_tag "modal_content"` ONLY when `turbo_frame_request?` is true (so the same view still works as a standalone page). For links/forms placed INSIDE the modal that should stay in it, use the context-aware `data: modal_turbo_frame_data` helper (returns `{ turbo_frame: "modal_content" }` in a modal, `{}` on a full page).
- **Forms**: use Rails `form_with` / `f.text_field` helpers, preserving Flowbite Tailwind classes on each field. Don't paste raw `<form>` / `<input>` HTML.
- **Copy**: never hardcode user-facing strings — use `t(".key")` (lazy lookup) and update both `en.yml` and `zh-CN.yml`.

## Regenerating

```bash
ruby .claude/skills/flowbite/scripts/fetch_source.rb
ruby .claude/skills/flowbite/scripts/generate_skills.rb
```

Source clones to `tmp/flowbite-source/` (gitignored).

## Components (43)

| Component | Reference |
|-----------|-----------|
| Accordion | `references/components/accordion.md` |
| Alerts | `references/components/alerts.md` |
| Avatar | `references/components/avatar.md` |
| Badges | `references/components/badge.md` |
| Sticky Banner | `references/components/banner.md` |
| Bottom Navigation | `references/components/bottom-navigation.md` |
| Breadcrumbs | `references/components/breadcrumb.md` |
| Button Group | `references/components/button-group.md` |
| Buttons | `references/components/buttons.md` |
| Cards | `references/components/card.md` |
| Carousel | `references/components/carousel.md` |
| Chat Bubble | `references/components/chat-bubble.md` |
| Copy to Clipboard | `references/components/clipboard.md` |
| Datepicker | `references/components/datepicker.md` |
| Device Mockups | `references/components/device-mockups.md` |
| Drawer (offcanvas) | `references/components/drawer.md` |
| Dropdown | `references/components/dropdowns.md` |
| Footer | `references/components/footer.md` |
| Forms | `references/components/forms.md` |
| Gallery (Masonry) | `references/components/gallery.md` |
| Indicators | `references/components/indicators.md` |
| Jumbotron | `references/components/jumbotron.md` |
| KBD (Keyboard) | `references/components/kbd.md` |
| List Group | `references/components/list-group.md` |
| Mega Menu | `references/components/mega-menu.md` |
| Modal | `references/components/modal.md` |
| Navbar | `references/components/navbar.md` |
| Pagination | `references/components/pagination.md` |
| Popover | `references/components/popover.md` |
| Progress Bar | `references/components/progress.md` |
| Rating | `references/components/rating.md` |
| Sidebar | `references/components/sidebar.md` |
| Skeleton | `references/components/skeleton.md` |
| Speed Dial | `references/components/speed-dial.md` |
| Spinner | `references/components/spinner.md` |
| Stepper | `references/components/stepper.md` |
| Table | `references/components/tables.md` |
| Tabs | `references/components/tabs.md` |
| Timeline | `references/components/timeline.md` |
| Toast | `references/components/toast.md` |
| Tooltip | `references/components/tooltips.md` |
| Typography | `references/components/typography.md` |
| Video | `references/components/video.md` |

## Forms (13)

| Component | Reference |
|-----------|-----------|
| Checkbox | `references/forms/checkbox.md` |
| File Input | `references/forms/file-input.md` |
| Floating Label | `references/forms/floating-label.md` |
| Input Field | `references/forms/input-field.md` |
| Number Input | `references/forms/number-input.md` |
| Phone Input | `references/forms/phone-input.md` |
| Radio | `references/forms/radio.md` |
| Range Slider | `references/forms/range.md` |
| Search Input | `references/forms/search-input.md` |
| Select | `references/forms/select.md` |
| Textarea | `references/forms/textarea.md` |
| Timepicker | `references/forms/timepicker.md` |
| Toggle | `references/forms/toggle.md` |

## Typography (9)

| Component | Reference |
|-----------|-----------|
| Blockquote | `references/typography/blockquote.md` |
| Headings | `references/typography/headings.md` |
| Horizontal Line (HR) | `references/typography/hr.md` |
| Images | `references/typography/images.md` |
| Links | `references/typography/links.md` |
| Lists | `references/typography/lists.md` |
| Paragraphs | `references/typography/paragraphs.md` |
| Text Decoration | `references/typography/text-decoration.md` |
| Text | `references/typography/text.md` |

## Plugins (4)

| Component | Reference |
|-----------|-----------|
| Charts | `references/plugins/charts.md` |
| Datatables | `references/plugins/datatables.md` |
| Unknown Component | `references/plugins/datepicker.md` |
| WYSIWYG Text Editor | `references/plugins/wysiwyg.md` |

## Customize (8)

| Component | Reference |
|-----------|-----------|
| Colors | `references/customize/colors.md` |
| Configuration | `references/customize/configuration.md` |
| Dark Mode | `references/customize/dark-mode.md` |
| Icons | `references/customize/icons.md` |
| Optimization | `references/customize/optimization.md` |
| RTL (Right-To-Left) | `references/customize/rtl.md` |
| Theming | `references/customize/theming.md` |
| Variables | `references/customize/variables.md` |

