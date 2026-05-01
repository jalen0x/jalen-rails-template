---
paths:
  - "app/policies/**/*.rb"
  - "app/controllers/**/*.rb"
  - "app/views/**/*.erb"
  - "test/system/**/*.rb"
  - "test/integration/**/*.rb"
---

# Authentication & Authorization

Authentication is security-critical. Authorization must be explicit, readable, and auditable.

## Authentication

- Do not build custom authentication unless there is no viable maintained option.
- Devise is the default authentication system in this template.
- GitHub OmniAuth is the only default OAuth provider; add providers only for a real product need.
- OAuth identity must use a stable provider identifier, not mutable email/username, when linking accounts.

## Authorization with Pundit

This template uses Pundit. Preserve the principle: permissions should be easy to audit.

- Policies should be explicit Ruby, not a dynamic DSL or metaprogramming puzzle.
- Scope user-owned resources at query time (`current_user.things.find(params[:id])`) before policy checks when ownership is the rule.
- Use Pundit policies when access rules are more nuanced than ownership.
- Keep policy names and predicates aligned with resource/action names.
- Do not hide authorization in view-only conditionals; controllers must enforce it.

## Role Modeling

When role-based access is needed, prefer stable business facts such as job title, department, organization role, or membership. Avoid temporary UI state or ad-hoc booleans as the core permission model unless the domain truly is boolean.

## Testing Access Controls

- Use system/integration tests for strategic, high-risk access paths.
- Do not test every role/action Cartesian product unless the risk demands it.
- Add helper methods such as `login_as` / `assert_no_access` when they reduce repetition without hiding intent.
