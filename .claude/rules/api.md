---
paths:
  - "app/controllers/api/**/*.rb"
  - "app/controllers/api_controller.rb"
  - "test/integration/api/**/*.rb"
  - "config/routes.rb"
---

# API Endpoint Standards

## Architecture

```ruby
# config/routes.rb
namespace :api do
  namespace :v1 do
    resources :widgets, only: [:index, :show, :create]
  end
end
```

```ruby
# app/controllers/api_controller.rb — base class for all API controllers
class ApiController < ApplicationController
  before_action :authenticate
  before_action :require_json

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      ApiKey.find_by(key: token, deactivated_at: nil).present?
    end
  end

  def require_json
    head :not_acceptable unless request.format.json?
  end
end
```

```ruby
# app/controllers/api/v1/widgets_controller.rb
class Api::V1::WidgetsController < ApiController
  def show
    widget = Widget.find(params[:id])
    render json: { widget: widget }
  end
end
```

## Authentication Strategy (Simplest Sufficient)

| Scenario | Approach |
|---|---|
| Frontend Ajax | Reuse existing Cookie authentication (Devise session) |
| Internal service-to-service | HTTP Token Auth — one key per client |
| Public API | JWT / OAuth (introduce only when needed, not prematurely) |

API Key table should have a conditional unique index: `add_index :api_keys, :client_name, unique: true, where: "deactivated_at IS NULL"`.

## JSON Responses

- **Always use a top-level key**: `render json: { widget: widget }`, not `render json: widget`. Adding metadata / pagination later won't break clients.
- Prefer Rails built-in `as_json` over extra serialization frameworks (jbuilder, fast_jsonapi) unless there's an explicit need.
- Define `as_json` in the model to control exposed fields:

```ruby
class Widget < ApplicationRecord
  def as_json(options = {})
    options[:methods] ||= [:user_facing_identifier]
    options[:except]  ||= [:widget_status_id]
    options[:include] ||= [:widget_status]
    super(options)
  end
end
```

## Content Negotiation

`ApiController`'s `before_action :require_json` uniformly rejects non-JSON requests with 406. Subcontrollers can `skip_before_action :require_json` to support other formats.

## Versioning

- Version number goes in the **URL** (`/api/v1/...`), not the `Accept` header — simple and straightforward.
- Only track major version numbers; backward-compatible changes don't bump the version.
- **Version per-endpoint** — don't upgrade the entire API at once.
- Establish a deprecation policy with enough migration time for clients.

## Testing

```
test/integration/api/v1/widgets_test.rb           # endpoint functionality
test/integration/api/authentication_test.rb       # 401 scenarios
test/integration/api/content_negotiation_test.rb  # 406 scenarios
```
