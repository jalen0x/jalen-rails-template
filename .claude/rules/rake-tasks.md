---
paths:
  - "lib/tasks/**/*.rake"
  - "bin/*"
---

# Rake Task Standards

## Organization Rules

- **One task per file** — filename = task name (`change_approved_widgets_to_legacy.rake`).
- **Directory structure matches namespace** — `lib/tasks/db/updates/prod/countries.rake` → `db:updates:prod:countries`.
- **Always write `desc`** — tasks without `desc` don't show up in `rake -T`, making them invisible.
- **Task names must be specific** — `change_approved_widgets_to_legacy`, not `legacy` or `update`.

## Task Body Is One Line

The task body does one thing: call the Service layer. Business logic does not go in `.rake` files.

```ruby
desc "Changes all Approved widgets to Legacy that need it"
task change_approved_widgets_to_legacy: :environment do
  LegacyWidgets.new.change_approved_widgets_to_legacy
end
```

## One-off Tasks

Use a `one_off` namespace, backed by service classes in `app/services/one_off/`:

```ruby
# lib/tasks/one_off/fix_widget_pricing.rake
namespace :one_off do
  desc "Fixes widgets created before the 0.95 validation"
  task fix_widget_pricing: :environment do
    OneOff::WidgetPricing.new.change_to_95_cents
  end
end
```

## Rake Task vs `bin/` Script

| Feature | Rake Task | `bin/` script |
|---|---|---|
| Needs Rails environment | Good fit | Requires manual loading |
| Tab completion | Not supported | Supported |
| Argument passing | Unusual syntax | Standard CLI arguments |
| Help docs | `desc` string | OptionParser auto-generates |

**Conclusion**: automation scripts that don't need Rails go in `bin/` (Ruby or bash). Scripts that need Rails go in `lib/tasks/`.

## Automation > Documentation

Rake tasks replace Markdown documents for operational procedures — humans make mistakes, automation doesn't. If you find the README saying "run these 5 steps…", that should be a Rake task.
