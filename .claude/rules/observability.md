---
paths:
  - "app/controllers/**/*.rb"
  - "app/jobs/**/*.rb"
  - "app/services/**/*.rb"
  - "app/models/current.rb"
  - "config/initializers/lograge*.rb"
  - "config/environments/production.rb"
---

# Observability & Operations

Observability is the ability to infer internal system state from external output. Monitor business outcomes, not only HTTP errors.

## Business Outcome Monitoring

For critical flows, prefer metrics that reflect user/business success:

- registrations completed
- payments succeeded
- imports completed
- emails delivered
- background workflows finished

HTTP 200/500 rates are supporting signals, not the goal. A marketing link pointing to staging can break registration while every controller returns 200.

## Logging Standards

When adding logs, make them actionable and attributable:

- Include request ID.
- Include current user ID when available and useful for audit/debugging.
- Include the code source (`[WidgetCreator]`, job class, controller action).
- Disambiguate object identifiers (`Widget/123`, not bare `123`).
- Do not log secrets, access tokens, private keys, or full credential payloads.

Use `Current` for request-scoped values that need to flow into services/jobs during a request.

## Exception Management

- Unknown exceptions should surface to the queue/monitoring system; do not rescue-and-swallow.
- Attach request ID and user ID to exception reports where the monitoring tool supports metadata.
- Keep exception inboxes actionable. If a noisy exception is expected, threshold or classify it rather than ignoring all failures.

## Performance

Measure before optimizing. Prefer automatic instrumentation first; add manual spans only when default measurements cannot answer the question. Remove one-off diagnostic spans/logs after the investigation unless they become a durable operational signal.

## Production Deployments

Kamal is self-managed infrastructure, not a PaaS. Changes to deployment, TLS, host setup, Docker images, queues, or storage should be treated as operations work and verified with the relevant deploy/runbook commands.
