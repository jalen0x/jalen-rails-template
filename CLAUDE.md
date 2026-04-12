# CLAUDE.md

Jalen Rails Template — Rails 8.1 starter with Devise, ViewComponent, and Solid Queue.

## Development Commands

```bash
bin/setup                    # Install dependencies and set up database
bin/dev                      # Start dev server (Overmind, auto-picks free port 3000-3099)
bin/rails test               # Minitest suite
bin/rails test:system        # Capybara + Selenium system tests
bin/rubocop                  # Omakase RuboCop
bin/rubocop -a               # Auto-fix
bin/brakeman --no-pager      # Security scanner
bin/bundler-audit check --update  # Gem CVE scan
bundle exec erb_lint --lint-all   # ERB linter
bin/ci                       # Run everything above locally
bin/rails db:prepare         # Set up database
bin/rails db:migrate         # Run migrations
bin/rails credentials:edit   # Edit encrypted credentials
```

### Custom Rake Tasks

```bash
rake setup:project    # Interactive — renders config/database.yml and config/deploy.yml from lib/templates/
```

## Architecture

- **Stack**: Rails 8.1, Ruby 4.0, PostgreSQL, Solid Queue / Solid Cache / Solid Cable, Propshaft, Hotwire (Turbo + Stimulus), TailwindCSS v4 + Flowbite 4, Devise, Pundit, ViewComponent + Lookbook
- **JS pipeline**: Hybrid — `importmap-rails` manages Stimulus/Turbo/app code; `bun run build` bundles Flowbite (via esbuild) into `app/assets/builds/flowbite.turbo.js`, which importmap pins. Don't assume "either importmap OR jsbundling" — both are intentional.
- **Authentication**: Devise with modular User concerns (`Users::Authenticatable`, `Users::Profile`, `Users::SoftDelete`). GitHub OmniAuth is the only OAuth provider.
- **Authorization**: Pundit (`ApplicationPolicy` included in `ApplicationController`).
- **Components**: ViewComponent under `app/components/`. Previews at `/lookbook` (development only) from `test/components/previews/`.
- **Deployment**: Kamal with project-specific `config/deploy.yml` + Cloudflare R2 for Active Storage in production.

## Key Rules

### Soft Delete (discard gem)

`User` uses `include Discard::Model` via `Users::SoftDelete` — call `user.discard` / `user.undiscard`, not `destroy`. Default scope is `kept`. Purge attached files before discarding (e.g., `image.purge if image.attached?`). If you introduce new soft-deletable models, follow the same concern pattern; avoid adding `default_scope -> { kept }` to unrelated models.

### Solid Queue Background Jobs

- **Never use `discard_on`** to drop jobs. Let them fail so they're visible in the dashboard, retryable, and debuggable. Exceptions: `discard_on ActiveRecord::RecordNotFound` and `discard_on ActiveJob::DeserializationError` are allowed (the record is gone, retrying is pointless).
- Don't rescue exceptions without re-raising — failures must surface.
- Use `retry_on` for transient external failures.
- Rails 8.1+: use `wait: :polynomially_longer` (renamed from `:exponentially_longer`).
- Use `deliver_later` for mailers in jobs; `deliver_now` blocks the worker.
- Use `perform_now` only when the caller truly needs the result before proceeding.

### Security

- **Authorization**: Queries must scope to the current user for user-owned resources — prefer `current_user.things.find(params[:id])` over `Thing.find(params[:id])`. Use Pundit policies for more complex access rules.
- Never expose internal error messages to end users — rescue early and return friendly messages.
- Never silently swallow exceptions — rescue specific errors and re-raise or report unknown errors.
- External API requests must be **outside** `ActiveRecord::Base.transaction` — slow/failed requests hold DB connections.
- External calls (HTTP, SSH, third-party SDK) must not run inline in controller actions — enqueue a Solid Queue job. See `.claude/rules/async-external-calls.md`.

### Database

- **Never add `default_scope`** — it causes hidden query side effects. The `Discard::Model`-provided `kept` scope in `Users::SoftDelete` is the narrow exception.
- Prefer `update!` over `update_columns` — don't skip `updated_at` and callbacks without a reason.
- Use `includes` / `preload` to avoid N+1 queries.
- Use `update_all` for batch operations, not per-record loops.
- Avoid reserved column names: `attributes`, `class`, `errors`, `hash`, `id`, `model_name`, `type` (STI). Prefix them (`llm_model`, `item_type`, `category_class`).

### Secrets & Config

Never hardcode secrets — use `Rails.application.credentials`. To add new credential sections, edit `lib/templates/rails/credentials/credentials.yml.tt` so future `bin/rails credentials:edit` runs in fresh environments pick them up automatically. Do not commit `config/master.key`.

## UI Color Classes (Flowbite 4 Semantic)

Use Flowbite 4 semantic color classes. Never use hardcoded Tailwind colors (`gray-*`, `blue-*`, `primary-*`) or `dark:` color overrides — semantic variables handle dark mode automatically.

Full variable reference: `node_modules/flowbite/src/themes/default.css`

```erb
<%# Links %>
class="font-medium text-fg-brand hover:underline"

<%# Primary buttons %>
class="text-white bg-brand box-border border border-transparent hover:bg-brand-strong focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Secondary buttons %>
class="text-body bg-neutral-secondary-medium box-border border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Danger buttons (outline) %>
class="text-danger bg-neutral-primary border border-danger hover:bg-danger hover:text-white focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Form inputs %>
class="bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full px-3 py-2.5 shadow-xs placeholder:text-body"

<%# Cards/containers %>
class="bg-neutral-primary-soft border border-default rounded-base shadow-xs"

<%# File input (default) %>
class="cursor-pointer bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full shadow-xs placeholder:text-body"

<%# Checkbox (label right of checkbox) %>
<div class="flex items-center">
  <input type="checkbox" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
  <label class="select-none ms-2 text-sm font-medium text-heading">Label</label>
</div>
```

Keep `text-white` on brand/danger backgrounds. Keep `after:bg-white` in toggle switches (slider stays white in both modes).

Prefer the existing `ButtonComponent` / `FormField::InputComponent` / `FormField::CheckboxComponent` / `FlashComponent` / `ModalComponent` over re-typing class strings. If you're copy-pasting the same classes twice, extend a component instead.

## Turbo Frame Modal Rules

Pages that serve as both a full page and a modal must only wrap themselves in `turbo_frame_tag "modal_content"` when `turbo_frame_request?` is true. On the link/form that opens the modal, use the `modal_turbo_frame_data` helper — never hardcode `data: { turbo_frame: "modal_content" }`.

```erb
<%= link_to "Edit", edit_thing_path(thing), data: modal_turbo_frame_data %>
```

The layout renders a top-level `<turbo-frame id="modal_content">` — don't nest a second one.

## Compact Instructions

When compressing context, preserve in priority order:
1. Architecture decisions and constraints (NEVER summarize away)
2. Modified files and their key changes
3. Current verification status (pass/fail commands)
4. Open TODOs and rollback notes
5. Tool outputs can be deleted — keep pass/fail only

## Verification

| Task | Done condition |
|------|---------------|
| Model / controller change | `bin/rails test` passes |
| System test change | `bin/rails test:system` passes |
| View / CSS change | Visual check + `bin/rubocop` + `bundle exec erb_lint --lint-all` pass |
| Component change | Preview at `/lookbook` looks right + `bin/rails test` passes |
| Full pre-commit sweep | `bin/ci` passes |

## Reference Documentation

Detailed guides are in `.claude/rules/` (auto-loaded by file path glob):

- `jobs.md` — Solid Queue job standards
- `rails-models.md` — Model conventions
- `rails-controllers.md` — Controller conventions
- `rails-views.md` — View conventions
- `stimulus-js.md` — Stimulus controller conventions
- `service-objects.md` — Service object conventions
- `tailwind-v4.md` — Tailwind v4 rules, breaking changes, design guidelines
- `testing.md` — Minitest conventions
- `async-external-calls.md` — Controller → Job → Turbo broadcast pattern for external I/O
- `r2-storage.md` — Cloudflare R2 Active Storage usage
