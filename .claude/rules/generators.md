---
paths:
  - "lib/generators/**/*.rb"
  - "lib/templates/**/*"
  - "config/template_base.rb"
  - "lib/template_base/**/*"
---

# Generators, Templates & Shared Defaults

Automation and generated code are preferable to documentation when enforcing architecture across apps.

## Generators

- Use Rails generators to codify repeated architectural decisions.
- Test generators when they contain non-trivial behavior.
- Thor string replacements can silently do nothing; generator code must fail loudly when an expected replacement target is missing.
- Generated files should follow the same service/controller/model/view rules as hand-written files.

## Template Base

- Shared defaults live in `lib/template_base/app/...`.
- App-specific customization copies the file into `app/...` first (`rails g template_base:override path/to/file`).
- Do not edit `lib/template_base/` for one application's local change.
- App overrides need an `Override: lib/template_base/...` comment with the reason for divergence.

## Sample Repositories Over Long Docs

When a pattern requires many files to work together, prefer a template/generator/sample implementation over prose instructions. The implementation is executable documentation.
