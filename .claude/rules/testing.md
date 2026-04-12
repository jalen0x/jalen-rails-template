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
