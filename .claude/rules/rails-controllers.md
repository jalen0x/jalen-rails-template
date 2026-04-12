---
paths:
  - "app/controllers/**/*.rb"
---

# Rails Controller Standards

- Add method comments with HTTP verb and path: `# GET /categories`.
- Use `before_action` for common setup.
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
