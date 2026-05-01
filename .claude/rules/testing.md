---
paths:
  - "test/**/*.rb"
---

# Testing Standards (Minitest)

- Use FactoryBot for test data by default. Do not add new Rails fixtures.
- Use block syntax: `test "valid user can login" do`.
- Use `setup` / `teardown` for common code.
- Test the minimum set of happy, sad, and edge paths needed for confidence; tests are risk reduction, not output.
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

Match test parameters to the real wire format:

- **Form/query params (non-JSON)** — use strings. Browser form submissions are text; passing `active: false` works in tests but `"false"` is truthy in production.

  ```ruby
  post widgets_path, params: { widget: { active: "false" } }
  ```

- **`as: :json` requests** — use native JSON types. Rails encodes params as JSON with proper headers, matching real API clients.

  ```ruby
  post api_widgets_path, params: { widget: { active: false, count: 42 } }, as: :json
  ```

## Service Tests

- **Don't mock Mailer** — see `mailers.md` testing section.
- **Decoy data**: for query-related tests, create both a distractor record and the target, preventing code from passing with `first` or the wrong `where`.
- Prefer testing the service seam directly for business edge cases instead of multiplying system tests.

## FactoryBot Best Practices

Realistic, valid factory records reduce hidden coupling between tests.

- Factories should create valid records by default.
- Use random-but-valid values (Faker is fine) to prevent tests from depending on one hardcoded value.
- Use `FactoryBot.lint traits: true` rather than writing redundant factory smoke tests.
- Use `FactoryBot.build` in mailer previews and other browser previews when persistence is not needed.
- Customize edge cases in-test with `update!` or explicit factory attributes.

## DB Constraint Tests Use `update_column`

When testing database-level constraints (check constraint / foreign key / unique index), bypass validations:

```ruby
test "negative price is rejected by DB constraint" do
  ex = assert_raises { @widget.update_column(:price_cents, -1) }
  assert_match(/price_must_be_positive/i, ex.message)
end
```

Using `update!` would be caught by validations first, so you'd never test the constraint itself.
