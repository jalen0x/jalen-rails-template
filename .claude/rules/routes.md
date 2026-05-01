---
paths:
  - "config/routes.rb"
  - "app/controllers/**/*_controller.rb"
---

# Routes & URLs

Routes are both implementation wiring and user-facing URLs. Keep them canonical, resource-oriented, and predictable.

## Canonical Resource Routes

- Default to `resources` / `resource`; do not hand-write standard CRUD routes with `get`, `post`, etc.
- Declare only implemented actions with `only:`. Avoid `except:` because it hides what the app actually supports.
- Use Rails URL helpers (`widget_path(widget)`) instead of string-building URLs.
- API routes follow the same rule: `namespace :api` / `namespace :v1` + `resources ..., only: [...]`.

```ruby
resources :widgets, only: [:index, :show, :new, :create]
resources :widget_ratings, only: [:create]
```

## More Resources, Not Custom Actions

If you want a custom action, first ask what resource it creates, updates, or deletes.

```ruby
# Bad: action-focused routes grow controllers sideways
resources :widgets, only: [:show] do
  post :update_rating
end

# Good: resource-focused route
resources :widget_ratings, only: [:create]
```

Custom member/collection actions are exceptions. Use them only when a real resource name would be dishonest or more confusing.

## Vanity URLs

Vanity, marketing, and legacy URLs are extra entry points. They do not replace canonical routes.

- First declare the canonical `resources` route.
- Put custom routes after resource routes in a clearly marked section.
- Prefer `redirect(...)` to the canonical path.
- Add a short comment explaining why the route exists.

```ruby
resources :widgets, only: [:index]

####
# Custom routes start here

# Used in podcast ads for the spring campaign.
get "/amazing", to: redirect("/widgets")
```

If a redirect is unacceptable, route directly to the same controller action and document why.

## Nested Routes

Never nest more than one level deep.

Use nesting only for:

1. True sub-resources that cannot exist independently of the parent.
2. Namespaces that disambiguate a separate user context (`customer_service/widgets`).
3. Content sections where the URL hierarchy is the user-facing organization.

Multiple namespaces or deep nesting are architecture smells: the app may be carrying too many responsibilities.
