---
paths:
  - "test/**/*.rb"
---

# Testing Standards (Minitest)

- Use fixtures for test data.
- Use block syntax: `test "valid user can login" do`.
- Use `setup` / `teardown` for common code.
- Test both happy and sad paths + edge cases.
- Keep tests focused on a single concern, independent, and idempotent.
- Never test the framework itself.
- Never pipe test output into `cat`: `bin/rails test`, not `bin/rails test | cat`.
- Never comment out tests — if a UI element is hidden, the test should still pass via direct URL or action.
- Component tests (for ViewComponent) live under `test/components/`. Preview files under `test/components/previews/` are exercised by Lookbook and don't need assertions, but the components they exercise should still have a proper `*_test.rb` under `test/components/`.

## Diagnostic Helper: `with_clues`

Automatically dump the current page HTML (and browser console) on test failure, then re-raise:

```ruby
def with_clues(&block)
  block.call
rescue Exception => ex
  puts "[with_clues] #{ex.message}"
  puts page.html if respond_to?(:page)
  raise
end
```

Only wrap the test you're actively debugging — don't leave `with_clues` in committed code. There's also a gem by the same name.

## Confidence Checks vs Real Assertions

Distinguish "preconditions" from "the behavior you're actually verifying." A precondition failure should say "the setup is wrong," not "the feature is broken":

```ruby
module TestSupport::ConfidenceCheck
  class ConfidenceCheckFailed < Minitest::Assertion
    def initialize(original)
      super("CONFIDENCE CHECK FAILED: #{original.message}")
    end
  end

  def confidence_check(&block)
    block.call
  rescue Minitest::Assertion => ex
    raise ConfidenceCheckFailed.new(ex)
  end
end

# Usage
confidence_check do
  refute_nil widget
  assert_redirected_to widget_path(widget)
end
assert_equal 12345, widget.reload.price_cents  # the real assertion
```

## System Test Assertions

- Regex + case-insensitive: `assert_selector "h1", text: /stembolt/i`. Exact matches break on trivial copy changes.
- **`data-testid` is a secondary tool** — don't add it everywhere from the start. First test against default DOM (`h1`/`h2`/semantic tags); introduce `data-testid` only when DOM changes cause false failures. Then: `Capybara.configure { |c| c.test_id = "data-testid" }`.
- Use `data-testid` instead of CSS classes — it clearly signals "test hook" and won't be accidentally removed during refactoring.

## Controller Tests

- **Parameters must be strings.** Production HTTP parameters are always strings. Passing `active: false` passes in tests but `"false"` is truthy in production — it will break.

```ruby
post widgets_path, params: { widget: { active: "false" } }  # correct
```

## Service Tests

- **Don't mock Mailer** — see `mailers.md` testing section.
- **"Decoy data"**: for query-related tests, ensure fixtures contain both a distractor record and the target, preventing code from passing with `first` or wrong `where`.

## Fixtures Best Practices

This project uses Rails built-in fixtures (not FactoryBot). Follow the DHH / 37signals style:

- **Keep 1–2 base fixtures per model**, named descriptively (`:admin`, `:regular_user`). Avoid explosive growth.
- **Use YAML anchors to DRY common attributes**:

```yaml
DEFAULTS: &DEFAULTS
  created_at: <%= 3.weeks.ago.to_fs(:db) %>

one:
  name: Acme Widget
  <<: *DEFAULTS
```

- **Reference associations by label**, never hardcode foreign key IDs:

```yaml
# widgets.yml
stembolt:
  name: Stembolt
  manufacturer: acme    # references :acme in manufacturers.yml
```

- **Customize edge cases in-test with `update!`**, not by creating new fixture variants:

```ruby
test "high priced widget triggers alert" do
  widget = widgets(:stembolt)
  widget.update!(price_cents: 999_99)
  # ...
end
```

- **Fixture data should pass model validations** (even though validations are bypassed during loading) — avoid testing against data states that can never exist in production.
- **Use `$LABEL` interpolation** for unique fields: `email: $LABEL@example.com`, `subdomain: $LABEL`.
- **ERB only for simple cases** (timestamps, password hashes) — don't put complex logic in fixture files.

## DB Constraint Tests Use `update_column`

When testing database-level constraints (check constraint / foreign key / unique index), bypass validations:

```ruby
test "negative price is rejected by DB constraint" do
  ex = assert_raises { @widget.update_column(:price_cents, -1) }
  assert_match(/price_must_be_positive/i, ex.message)
end
```

Using `update!` would be caught by validations first, so you'd never test the constraint itself.
