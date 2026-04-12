---
paths:
  - "app/models/**/*.rb"
---

# Rails Model Standards

- Use `has_prefix_id` (from the `prefixed_ids` gem) for models exposing public IDs.
- Use keyword syntax for enums: `enum :status, [:draft, :published]`.
- Use `normalizes` for attribute normalization.
- Use `store_accessor` for JSON columns.
- Use `attribute :field, default: value` for defaults.
- Use `counter_cache` for `belongs_to` relationships needing counts.
- Define constants at the top of the file.
- Use `class Module::ClassName` form, not nested `module Module; class ClassName` definitions.
- Pass models (not IDs) to jobs — serialized automatically via GlobalID.
- Use Rails associations instead of manual SQL.
- Use `includes` / `preload` to avoid N+1 queries.
- Use `update_all` for batch operations — not per-record loops (watch for SQL length with large ID sets).
- Models must not depend on Helpers — put config/logic in concerns instead.
- Don't extract a concern for one-time use — keep simple logic inline.
- **No `default_scope`** — causes hidden query side effects. The `kept` scope that `Discard::Model` provides on soft-deletable models is the narrow exception.
- Prefer `update!` over `update_columns` — don't silently skip `updated_at` and callbacks.
