---
paths:
  - "Gemfile"
  - "Gemfile.lock"
  - "package.json"
  - "bun.lock"
  - "bun.lockb"
  - ".github/dependabot.yml"
  - "bin/update"
---

# Dependency Management

Dependencies have carrying cost. Keep them current, keep the set small, and explain every pin.

## Adding Dependencies

- Prefer Rails, Ruby stdlib, browser platform APIs, and existing project dependencies.
- Add a new gem/npm package only for a concrete, current need with clear benefit.
- Do not add a dependency for a one-off helper, thin wrapper, or speculative future feature.
- If the dependency changes architecture or runtime operations, discuss it before adding it.

## Version Strategy

- Ruby should stay within the latest two minor versions when practical.
- Rails should use an intentional constraint appropriate for app stability.
- Other gems should avoid over-specific pins unless required.
- Every hard pin or upper bound must include a comment explaining why it exists and when it can be removed.

```ruby
# Pinned until flowbite 4.1 fixes modal focus regression: <issue URL>
gem "flowbite", "4.0.0"
```

## Update Workflow

- Prefer frequent small dependency updates over rare large jumps.
- Keep Dependabot enabled and review its PRs regularly.
- A `bin/update` script, when present, should run dependency updates, show outdated packages, then run `bin/ci`.
- After dependency updates, run the smallest verification that covers the changed package; use `bin/ci` for broad upgrades.

## Comments Are Good Here

Use comments for dependency pins, `.gitignore` exceptions, and non-obvious config. These comments explain decisions that are otherwise invisible and prevent future cargo-culting.
