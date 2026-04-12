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

## Rich Result Objects (Not Booleans / nil)

Service methods should return an instance of a `Result` class nested inside the service, not true/false / model / nil.

```ruby
class WidgetsCreator
  def create_widget(widget_params)
    widget = Widget.create(widget_params)
    Result.new(created: widget.valid?, widget: widget)
  end

  class Result
    attr_reader :widget
    def initialize(created:, widget:)
      @created = created
      @widget = widget
    end
    def created? = @created
  end
end
```

Rules:
- **Past-tense predicates**: `created?` / `charged?` / `published?`, not `success?` / `ok?`. When the UI later needs to distinguish `created? && pending_review?`, only the Result class changes.
- Each service defines **its own** Result class, inline — no shared Result gem. Ruby 3.2+ `Data.define` is equivalent to a hand-written class.
- When no return value is needed, don't return one (e.g. a pure side-effect method like `notify_finance_team`).

## Naming: Verb Method Names, Never `call`

- Classes are **nouns**: `WidgetsCreator`, `PromotionalWidgetsCreator` — not `WidgetService`.
- Methods are **verbs**: `create_widget(widget_params)`, not `call`. `call` looks identical across all services, grep can't distinguish intent, and a single-method class can't use private methods for decomposition.
- Invocations read like English: `WidgetsCreator.new.create_widget(params)`.

## Against Full Dependency Injection

Don't inject every dependency via `initialize` for "testability":

```ruby
# Don't
def initialize(notifier:, sales_tax_api:, repository:)

# Good
def initialize(notifier:)  # only inject what the caller truly needs to configure
```

Ruby's mocking can `allow(Widget).to receive(:create)` directly — no DI needed for testing. Full DI makes code appear more flexible than it actually is, obscuring real dependencies.

The constructor accepts only dependencies **the caller must configure**; everything else (`Widget`, `AdminMailer`, `Stripe::`) is a hard dependency.
