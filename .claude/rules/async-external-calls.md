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
  RestartInstanceJob.perform_later(@instance)
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

  def perform(instance)
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

## Code Review Signal

Flag these patterns in controller code — they indicate synchronous external calls:

- `Net::SSH`, `net/http`, `Faraday`, `HTTParty`, `RestClient`
- `Aws::S3`, `Stripe::`, `Octokit::`, `Cloudflare::`, `Telegram::`
- `URI.open`, `open-uri`
- `system()`, backticks, `Open3` calling remote hosts
- Any `sleep` in a controller
