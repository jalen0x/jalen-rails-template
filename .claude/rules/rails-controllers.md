---
paths:
  - "app/controllers/**/*.rb"
---

# Rails Controller Standards

- Add method comments with HTTP verb and path: `# GET /categories`.
- Use `before_action` only for cross-cutting concerns (`authenticate_user!`, Pundit setup, `rescue_from`); load per-action data explicitly inside the action.
- Use `pagy` for pagination: `@pagy, @resources = pagy(Resource.all)`.
- Use `params.expect(:resource)` instead of `params.require`.
- Use `status: :see_other` for redirects after `DELETE`.
- Use `status: :unprocessable_content` for failed creates/updates.
- Use `respond_to` for format handling (HTML/JSON).
- Namespace API controllers under `Api::V1`.
- Keep controllers thin — but don't extract services without real business logic. A wrapper that just delegates adds complexity, not clarity. When in doubt, inline is better than over-abstraction.
- Use ActiveModel validations for param checking — don't write manual `if params[:x].blank?` guards.
- Use Turbo / Hotwire for dynamic updates, not custom Ajax or `fetch`.
- **Scope queries to the current user** for user-owned resources: `current_user.things.find(params[:id])` — never bare `Thing.find(params[:id])`. Use Pundit policies when access rules are more nuanced than ownership.
- External API requests must be **outside** `ActiveRecord::Base.transaction` — slow/failed requests hold DB connections.
- External calls (SSH, HTTP API, third-party SDK) must not run inline in controller actions — enqueue a job instead. See `async-external-calls.md` for the pattern and exceptions.
- Never render inline HTML (`render inline:`) — use flash messages or view templates.

## Controllers Are Configuration, Not OOP

Rails controllers are an internal DSL: action methods take no arguments, return values are ignored, `render` / `redirect_to` can only be called once, and you can't instantiate them yourself. Embrace this and the code stays minimal.

A controller's job is exactly four things:
1. Receive the HTTP request
2. **Type-coerce parameters** — HTTP is a text protocol; the controller is the **only place** to convert strings into business types (e.g. dollar string → cent integer, date string → `Date`). The Service layer should not know about "dollars to cents."
3. Call the Service layer
4. Route the response based on the result (redirect / render)

### `before_action` vs Explicit Private Methods

- Cross-cutting concerns (`authenticate_user!`, Pundit verification, `rescue_from`) → `before_action` / controller-level hooks.
- Per-action data loading (`@manufacturer = load_manufacturer`) → **call a private method explicitly**, not `before_action :set_manufacturer`. Explicit calls make execution order clear, easy to trace, and safe to refactor.

### Ideally Expose One `@instance_variable`

Each action should expose only one instance variable to the view. Three exceptions:
1. Reference data (dropdown options, country lists)
2. Global context (`current_user` via `helper_method`)
3. Persisted UI state (currently active tab)

**Don't** use Presenter/Decorator to solve "the view needs a combination of models" — use an Active Model view-specific resource class instead (see `rails-views.md`).

### Turbo Pitfall

- Failed form submissions must use `render :new, status: :unprocessable_content` (renamed from `:unprocessable_entity` in Rails 8). Without the status, Turbo won't replace the form → user sees a blank page or no response.

Routing rules are in `routes.md`. API endpoint rules are in `api.md`.
