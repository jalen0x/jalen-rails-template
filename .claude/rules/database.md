---
paths:
  - "db/migrate/**/*.rb"
  - "db/structure.sql"
  - "config/initializers/postgres*.rb"
---

# Database & Migrations

> Data is more important than code. Code can be rewritten; data loss is an extinction-level event. Data integrity must rely on database constraints, not Rails validations (validations are a UX tool — `update_column` / external writes / `validates_uniqueness_of` race conditions all bypass them).

## Logical Model First

For non-trivial data changes, draft the logical model before writing the migration:

- entities in user/business language,
- attributes and types,
- required vs optional,
- uniqueness and other constraints,
- main queries the UI/workflows need.

The logical model builds consensus; the physical model enforces correctness. The less familiar the domain, the more important this step is.

## Schema Format

- This project uses `config.active_record.schema_format = :sql` — the source file is `db/structure.sql`, not `db/schema.rb`. This allows check constraints, enum types, partial indexes, and other Postgres features.
- `t.timestamps` / `t.datetime` generate **TIMESTAMPTZ** (not TIMESTAMP) — configured in an initializer to eliminate timezone ambiguity.

## Column Type Choices (Postgres)

| Data | Use | Avoid |
|---|---|---|
| Strings | `t.text` | `t.string` (Postgres treats them identically; `varchar(n)` only adds accidental truncation) |
| Money | Integer cents `t.integer :price_cents` | `t.float` / `t.decimal` in dollars |
| Booleans | `t.boolean` | `"y" / "n"` string columns |
| Date (no time) | `t.date` | Midnight timestamps |
| Timestamps | TIMESTAMPTZ (guaranteed by the initializer) | Plain `TIMESTAMP` |

## Every Column Must Explicitly Declare `null:` and `comment:`

```ruby
create_table :widgets, comment: "What we sell" do |t|
  t.text :name,        null: false, comment: "Human-readable name"
  t.integer :price_cents, null: false, comment: "Price in cents (USD)"
  t.text :description, null: true,  comment: "Optional marketing blurb"
  t.timestamps
end
```

- Even when null is allowed, write `null: true` — it proves you considered it.
- `comment:` is for the next person — one comment is worth ten lines of code.

## Constraint Priority: DB > Rails

Ranked by reliability:

1. **Database constraints** (most reliable) — NOT NULL / foreign keys / unique indexes / `add_check_constraint`
2. **Lookup tables** (replace Rails enums when the value set may expand or needs metadata)
3. **Rails validations** (UX tool for friendly error messages)

```ruby
# check constraint
add_check_constraint :widgets, "price_cents > 0", name: "price_must_be_positive"

# foreign key + index
t.references :manufacturer, null: false, foreign_key: true, index: true

# composite unique index
add_index :widgets, [:name, :manufacturer_id], unique: true
```

## Lookup Tables > Rails Enums

When the value set may change (new statuses) or needs associated metadata (label, sort_order), use a lookup table instead of `enum`:

```ruby
create_table :widget_statuses do |t|
  t.text :status, null: false
  t.text :label
  t.integer :sort_order
  t.timestamps
end

# widgets table references via foreign key
t.references :widget_status, null: false, foreign_key: true, index: true
```

Hardcoded boolean states (`active` / `deleted_at`) or simple two-way choices that will never expand can use `enum`.

## Migration Workflow

Write iteratively:

```bash
bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test
# verify with psql or bin/psql if the project has that helper
bin/rails db:rollback
bin/rails db:rollback RAILS_ENV=test
# continue iterating on the migration
```

Don't write the entire migration in one go — migrate/rollback after each DSL addition to keep `db/structure.sql` diffs readable.

## Avoid `update_columns` (Most of the Time)

- `update_columns` skips `updated_at` and callbacks — rarely what you actually want. Default to `update!`.
- Exception: intentionally use `update_column` to bypass validations when testing DB constraints (see `testing.md` "DB Constraint Tests").
- Alias: `attributes=` + `save(validate: false)` is equally prohibited.

## Test DB Constraints

Constraints need tests — otherwise someone may remove `null: false` and nobody notices:

```ruby
test "price must be positive" do
  ex = assert_raises { @widget.update_column(:price_cents, -1) }
  assert_match(/price_must_be_positive/i, ex.message)  # match exact constraint name
end
```
