---
paths:
  - "app/services/**/*.rb"
---

# Service Object Standards

Services are the business-logic seam between Rails boundary objects and the domain. First principle: a call site should reveal behavior and read like a business sentence, not a framework invocation.

## Naming

- **Classes are business nouns**: `WidgetCreator`, `LegacyWidgets`, `ClaudeMessageTokenCounter`, `ClaudeModelCatalog`.
- **No `Service` suffix** — it adds a layer label, not meaning. Drop it.
- **Methods are verbs**: `create_widget(params)`, `count_tokens(messages:)`, `change_to_95_cents`.
- **No generic `run` / `call` / `perform`** — they erase intent and block private-method decomposition.
- Sub-namespaces only for real grouping (`OneOff::`, `Admin::`).

```ruby
# Good — reads like a sentence
ClaudeMessageTokenCounter.new.count_tokens(messages:)
LegacyWidgets.new.change_approved_widgets_to_legacy

# Bad — framework noise
CountClaudeMessageTokensService.new.run
```

## Return Values

When a method needs to return more than one thing, use a nested `Result` class.

```ruby
class WidgetCreator
  def create_widget(params)
    widget = Widget.create(params)
    Result.new(created: widget.valid?, widget: widget)
  end

  class Result
    attr_reader :widget
    def initialize(created:, widget:) = (@created, @widget = created, widget)
    def created? = @created
  end
end
```

- **Fields are business nouns**: `widget:`, `models:`, `token_count:` — not generic `payload:` / `data:` / `result:`.
- **Past-tense predicates**: `created?` / `charged?` / `published?` — not `success?` / `ok?`. Future UI needs (`created? && pending_review?`) then only touch the Result class.
- Pure side-effect methods return nothing.

## Don't Over-Decompose

- Don't wrap a single delegation in a service — inline it.
- Don't create single-use helper classes (`SomethingFinder` called once) — make it a private method.
- Don't inject dependencies just for testability. `allow(Widget).to receive(:create)` works directly. Constructor takes only what the caller must configure.

## Other

- Business data/context goes in the verb method (`create_widget(widget)`), not split between `initialize` and `call`. Constructors take only dependencies the caller must configure.
- Wrap multi-step DB work in `ActiveRecord::Base.transaction`.
- External API calls (HTTP, SSH, third-party SDK) stay **outside** transactions and belong in a Solid Queue job — see `async-external-calls.md`.
- Never swallow exceptions silently.
