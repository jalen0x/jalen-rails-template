---
paths:
  - "app/controllers/**/*.rb"
  - "app/jobs/**/*.rb"
---

# Async External Calls

Controller actions must not block Puma threads with external I/O. Route all external calls through Solid Queue jobs.

## What Counts as an External Call

Any call that leaves the Ruby process: SSH, HTTP API, SMTP, DNS, gateway RPC, third-party SDK (S3/R2, GitHub, Cloudflare, OpenAI, Stripe, Telegram, etc.).

## Rule

| Expected latency | Approach |
|-----------------|----------|
| >1s | **Must** be a background job |
| 200ms – 1s | Should be a job; inline only with justification |
| <200ms | Inline OK, but set library-specific timeouts |

## Exceptions (Inline Allowed)

- Redirect URL generation (OAuth authorize, checkout URLs) — the browser needs the URL synchronously.
- Webhook signature verification — must run before processing.
- OAuth token validation — single fast call that gates the request.

## LLM and Streaming Calls

LLM APIs are external calls, even when the UI wants token streaming. Default to a background job that persists status/output and broadcasts progress through Turbo Streams or Action Cable.

Inline request-path streaming is an explicit product exception, not the default. If you keep it inline, document the exception and implement all of these boundaries:

- short client/open/read timeouts;
- user cancellation behavior;
- retry or no-retry semantics;
- partial-output persistence or discard rules;
- user-visible error state;
- monitoring/error reporting;
- rate limiting and concurrency limits;
- no open database transaction during the stream.

Keep provider-specific streaming code behind a small adapter so controllers do not become SDK orchestration code.

## Pattern: Controller → Job → Turbo Broadcast

```
Controller                    Job                         Frontend
    │                          │                              │
    ├─ enqueue job ───────────>│                              │
    ├─ redirect / 202          │                              │
    │                          ├─ external call               │
    │                          ├─ update model status         │
    │                          ├─ broadcast via Turbo ───────>│
    │                          │                              ├─ UI auto-refreshes
```

### Controller: enqueue and return

```ruby
def restart
  RestartInstanceJob.perform_later(@instance.id)
  respond_to do |format|
    format.html { redirect_to @instance, notice: t(".enqueued") }
    format.json { head :accepted }
  end
end
```

### Job: external call + retry + broadcast

```ruby
class RestartInstanceJob < ApplicationJob
  queue_as :default
  retry_on Net::OpenTimeout, Net::ReadTimeout, attempts: 5, wait: :polynomially_longer

  def perform(instance_id)
    instance = Instance.find(instance_id)
    SshClient.for_instance(instance).service_restart("app")
    instance.update!(status: :running)
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    instance.update!(status: :failed)
    raise e
  end
end
```

### Frontend: subscribe to Turbo Stream

```erb
<%= turbo_stream_from [current_user, :instance_status, @instance.id] %>
```

The model broadcasts status change automatically via an `after_commit` callback.

## Job Checklist

When creating a job for an external call:

- [ ] `retry_on` transient network errors with `wait: :polynomially_longer`
- [ ] Concurrency guard (`limits_concurrency`) if multiple requests can hit the same resource
- [ ] Update model status on success **and** failure
- [ ] Broadcast via Turbo Streams so the UI reflects the result
- [ ] Don't rescue-and-swallow — re-raise unknown errors so the queue and monitoring see them

## Correct Usage of Callback Enqueuing

Enqueuing jobs from callbacks is a Rails Core–endorsed pattern (DHH: "all jobs should enqueue after the commit"), but rules apply.

### Transaction-internal callbacks (`after_create` / `after_save`): don't enqueue directly

These callbacks run inside the DB transaction. The worker may execute the job before the record commits → `RecordNotFound`.

Use `after_commit` when a callback must enqueue a secondary responsibility after durable state changes.

### `after_commit` callbacks are appropriate for secondary responsibilities

`after_commit` runs after the transaction commits. Suitable for **secondary responsibilities** (37signals, Jorge Manrubia's classification):

- Notification emails, push notifications
- Audit logs
- Stats / cache invalidation
- Turbo Stream broadcasts

These are orthogonal concerns — declaratively plugged in, not affecting core logic.

### Primary business logic goes in the Service layer

**Core workflow orchestration** (cross-model operations, complex conditional branches, flows needing Result Objects) does not belong in callbacks. Use the Service layer for explicit invocation. This is a readability and maintainability concern:

- Callbacks are implicit — complex flows destroy linear readability
- High fan-in model callbacks affect all creation paths (seed, migration, console) — not all of which should trigger the side effect
- Service layer flows can be tested independently

### Code review signals for callback enqueuing

- `after_create` / `after_save` + `perform_later` / `deliver_later` → require `after_commit`
- `after_commit` + simple enqueue → OK (secondary responsibility)
- `after_commit` + complex business logic → suggest moving to Service layer

## Code Review Signal

Flag these patterns in controller code — they indicate synchronous external calls:

- `Net::SSH`, `net/http`, `Faraday`, `HTTParty`, `RestClient`
- `Aws::S3`, `Stripe::`, `Octokit::`, `Cloudflare::`, `Telegram::`
- `URI.open`, `open-uri`
- `system()`, backticks, `Open3` calling remote hosts
- Any `sleep` in a controller
