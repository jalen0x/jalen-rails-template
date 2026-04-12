---
paths:
  - "app/services/**/*.rb"
---

# Service Object Standards

- Name: verb + noun + "Service" (e.g. `CreateUserService`).
- Use `class Service::ClassName` form, not nested module/class.
- Accept params in `initialize`, execute in `run` (or `call` / `perform`).
- Keep focused on a single responsibility.
- Wrap multi-step operations in `ActiveRecord::Base.transaction`.
- Handle errors via exceptions or a result object.
- Validate parameters in `initialize` or a dedicated method.
- Calls should read like English: `FetchService.fetch(feed)` — not `FetchService.new(feed:).run`.
- Define Result objects inside the service class to clarify return fields.
- **Don't extract a service that just delegates** without business logic — inline is better than a wrapper.
- Concerns (`app/controllers/concerns/`, `app/models/concerns/`) don't belong in `app/services/`.
