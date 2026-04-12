---
paths:
  - "app/mailers/**/*.rb"
  - "app/views/*_mailer/**/*.erb"
  - "test/mailers/**/*.rb"
---

# Mailer Standards

## Mailers Are Boundary Objects

Like controllers — they accept data, render output, and **contain no business logic**.

```ruby
class FinanceMailer < ApplicationMailer
  helper :application

  def high_priced_widget(widget)
    @widget = widget
    mail to: "finance@example.com"
  end
end
```

## Delivery

- **`deliver_later`** (default) — goes through the Solid Queue queue, doesn't block the current thread.
- **`deliver_now`** — only when the caller truly needs synchronous completion (rare).
- Don't call `deliver_later` directly from AR callbacks — see `async-external-calls.md` for callback enqueue rules.

## Email Styling

- **CSS classes don't work** in emails → use **inline styles** only.
- Use `<table>` for layout, not flexbox / float / grid.
- The design system is a specification; CSS is one implementation, inline styles another — manually look up the design system's concrete values (e.g. `0.25rem`) to apply them.

## Organization

- Reusable email components go in `app/views/mailer_components/`.
- Mailer-specific helpers go in `app/helpers/mailer_helpers.rb`.
- Pull in shared helpers via `helper :application`.

## Previews

Use `test/mailers/previews/` to preview emails in the browser:

```ruby
class FinanceMailerPreview < ActionMailer::Preview
  def high_priced_widget
    widget = Widget.new(
      name: "Stembolt",
      price_cents: 8100_00,
      manufacturer: Manufacturer.new(name: "Cyberdyne")
    )
    FinanceMailer.high_priced_widget(widget)
  end
end
```

Build preview objects with `Model.new(attrs)` — don't write to the database.

## Testing

- Don't mock Mailer — clear `ActionMailer::Base.deliveries` and assert on the array contents.
- Assert on recipient address and key content, not the full HTML:

```ruby
assert_equal 1, ActionMailer::Base.deliveries.size
mail = ActionMailer::Base.deliveries.first
assert_equal "finance@example.com", mail["to"].to_s
assert_match /Stembolt/, mail.text_part.to_s
```
