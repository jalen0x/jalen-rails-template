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
- Pass primitive IDs/snapshot values to jobs by default; pass models only when GlobalID lookup semantics are intentional.
- Use Rails associations instead of manual SQL.
- Use `includes` / `preload` to avoid N+1 queries.
- Use `update_all` for batch operations — not per-record loops (watch for SQL length with large ID sets).
- Models must not depend on Helpers — put config/logic in concerns instead.
- Don't extract a concern for one-time use — keep simple logic inline.
- **No `default_scope`** — causes hidden query side effects. The `kept` scope that `Discard::Model` provides on soft-deletable models is the narrow exception.
- Prefer `update!` over `update_columns` — don't silently skip `updated_at` and callbacks.

## Active Record Should Only Contain Three Kinds of Code

1. **Configuration DSL** — associations, validations, `enum`, `normalizes`, `has_prefix_id`.
2. **Class methods**: used in multiple places AND pure database logic. E.g. `def self.fresh = where(status: "fresh")`. Queries containing business rules (e.g. "within 10 days") belong in the Service layer.
3. **Instance methods**: **core domain concepts** derivable directly from persisted data (e.g. `user_facing_identifier`). Display-only strings (`def short_status = status[0]`) go in helpers or View Components.

Everything else stays out of Active Record — putting business logic in the highest fan-in class = putting "code most likely to have bugs" in "the class referenced by the most places." Orchestration across models / external systems goes in `app/services/`.

## Callbacks & Network I/O

- Use `normalizes` instead of `before_validation` for data normalization (Rails 7.1+).
- **Rules for enqueuing from callbacks** (`perform_later`, `deliver_later`):
  - **`after_create` / `after_save` (inside transaction): don't enqueue directly** — the worker may execute before the record commits → `RecordNotFound`. On Rails 8.1, add `self.enqueue_after_transaction_commit = true` in `ApplicationJob` (default in 8.2).
  - **`after_commit` callbacks may enqueue** — suitable for **secondary responsibilities** (notifications, audit logs, cache invalidation, Turbo broadcasts). This is a Rails Core–endorsed pattern (DHH: "all jobs should enqueue after the commit").
  - **Primary business logic** (core workflow orchestration, cross-model operations) goes in the Service layer, not callbacks — this is a readability and fan-in concern, not an enqueue safety issue.
  - Distinction (37signals, Jorge Manrubia): **secondary responsibilities** (simple, orthogonal, declaratively plugged in) → callbacks OK. **Primary logic** (complex flows defining core entity behavior) → explicit Service.
- Never rescue unknown exceptions in callbacks and swallow them — failures must surface.

## Validations: a UX Tool, Not a Data Integrity Tool

- Validations exist for **user experience**, not data integrity. Three reasons: external writes bypass them; Rails exposes APIs that skip them (`update_column`, `save(validate: false)`); `validates_uniqueness_of` has a race condition.
- Data integrity relies on **DB constraints** (see `database.md`). Validations and constraints are complementary: constraints are the safety net, validations provide friendly error messages.
- Simple validations (`presence: true`, `numericality`) **don't need tests** — they're configuration, not logic. Only complex custom validators / callbacks warrant unit tests.

## Scopes / Business Queries

- Scopes can be fully replaced by class methods — pick one style and stay consistent.
- Queries containing business rules ("what counts as fresh") are not scopes or class methods — they're Service layer code.
- Don't extract a concern preemptively — wait for the third occurrence.
