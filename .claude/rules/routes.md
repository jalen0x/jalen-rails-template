---
paths:
  - "config/routes.rb"
  - "app/controllers/**/*_controller.rb"
---

# Routes & URLs

Routes are both implementation wiring and user-facing URLs. Keep them canonical, resource-oriented, and predictable.

## Route Design Order

When adding a route, make decisions in this order:

1. Name the resource in business nouns.
2. Choose the smallest standard action set (`index`, `show`, `new`, `create`, `edit`, `update`, `destroy`).
3. Decide plural `resources` vs singular `resource`.
4. Add nesting or namespace only if it changes the resource's identity or user context.
5. Add vanity/custom URLs only after the canonical route exists.

If you cannot name the resource without a verb, pause before editing `config/routes.rb`.

## Canonical Resource Routes

- Default to `resources` / `resource`; do not hand-write standard CRUD routes with `get`, `post`, etc.
- Declare only implemented actions with `only:`. Avoid `except:` because it hides what the app actually supports.
- Use Rails URL helpers (`widget_path(widget)`) instead of string-building URLs.
- Use query params for filtering, sorting, search, and tab state on an `index`; do not add `get "/widgets/search"` when `widgets_path(q: "...")` is the resource.
- API routes follow the same rule: `namespace :api` / `namespace :v1` + `resources ..., only: [...]`.

```ruby
resources :widgets, only: [:index, :show, :new, :create]
resources :widget_ratings, only: [:create]
```

## Singular vs Plural Resources

Use singular `resource` when the URL identifies exactly one thing in the current context and no `:id` is needed:

```ruby
resource :profile, only: [:show, :edit, :update]
resource :dashboard, only: [:show]
resource :account_settings, only: [:show, :update]
```

Use plural `resources` when the user can address a collection or a specific record by ID.

Do not route through the current user just to be explicit. Prefer `/profile` over `/users/:user_id/profile` when the controller uses `current_user`. Use a user-scoped route only when the URL is truly about another user's public/admin resource.

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

Common reframes:

- `approve_widget` → `widget_approvals#create`
- `publish_post` → `post_publication#create`
- `cancel_subscription` → `subscription_cancellation#create` or `subscription#destroy`
- `resend_invite` → `invitation_deliveries#create`
- `archive_project` → `project_archival#create`

If the action changes normal attributes on the primary resource, use `update`. If it creates a domain event, relationship, request, or workflow, create a named resource.

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

Nesting is a strong domain statement: the child resource cannot be identified without the parent. If the child can later be listed, linked, or managed independently, use a top-level resource with a parent ID param instead.

```ruby
# Safer when ratings may later be listed independently
resources :widget_ratings, only: [:create]

# Only if a rating has no identity outside its widget
resources :widgets, only: [:show] do
  resources :ratings, only: [:create]
end
```

## Namespaces

Use namespaces for different user contexts with different controllers/views/permissions, such as `admin`, `customer_service`, or `api/v1`.

Do not namespace for URL aesthetics. If the normal canonical URL is ugly but correct, keep it and add a vanity redirect only when a user-facing URL is required.

## Verification

After changing routes:

- run `bin/rails routes -g <resource>` for the touched resource;
- check that every route maps to an implemented controller action;
- use URL helpers in views/tests instead of literal paths;
- add an integration/system test only for meaningful access, authorization, redirect, or request/response behavior — not for a route table smoke test.
