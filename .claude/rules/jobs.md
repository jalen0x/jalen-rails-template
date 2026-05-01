---
paths:
  - "app/jobs/**/*.rb"
---

# Job Standards

- Use `retry_on` for external resource requests to handle transient failures.
- Notification jobs must be retryable — don't catch unknown errors, let the job system retry.
- Batch operations: avoid broadcast storms — group by user or let the frontend self-refresh.
- Scheduled jobs (e.g. nightly cleanup): skip real-time broadcasts — users are offline.
- **Never use `discard_on`** — let jobs fail for debugging and retry. Exceptions: `discard_on ActiveRecord::RecordNotFound` and `discard_on ActiveJob::DeserializationError` are allowed (records no longer exist, retrying is pointless).
- Don't rescue exceptions without re-raising — failures must surface.
- Rails 8.1+: use `wait: :polynomially_longer` (renamed from `:exponentially_longer`).
- Outside jobs, use `deliver_later` so controllers/services do not block on SMTP work. Inside a job, `deliver_now` is acceptable when that job is the async boundary and owns the side effect.
- Use `perform_now` only when the caller truly depends on the result before continuing.
- Pass primitive arguments by default: IDs, strings, numbers, booleans, and explicit snapshot values. Passing models via GlobalID is allowed only when you have considered serialization and retry behavior.

## Idempotency

Jobs get retried automatically. For **every line** in a job, ask: "if this line succeeds, the next line raises, and the entire job re-runs, what happens?" No double side effects (double charges, duplicate emails, double inventory deductions) = idempotent.

### Splitting Strategy

Don't pack multiple independent side effects into one job. Split into single-effect jobs:

```ruby
# Bad: one job with multiple steps; retry may send duplicate emails
PostWidgetCreationJob.perform_later(widget.id)

# Good: each job has a single side effect and primitive args
HighPricedWidgetCheckJob.perform_later(widget.id, widget.price_cents)
WidgetFromNewManufacturerCheckJob.perform_later(widget.id, widget.manufacturer.created_at.to_s)
```

### Pass Snapshot Values, Not "To Be Queried"

A job may execute long after enqueue; underlying data may change. If business logic depends on the value **at enqueue time**, pass it as an argument instead of re-querying in `perform`:

```ruby
HighPricedWidgetCheckJob.perform_later(widget.id, widget.price_cents)  # snapshot
```

The job can still `Widget.find` for the latest record when needed.

### Serialization Gotchas (Must Write Tests)

- ActiveJob arguments go through serialization: symbol keys can become strings, Date/DateTime values can lose type fidelity depending on adapter and serializer path.
- Prefer primitive args so retry behavior is obvious. For DateTime, explicitly `.to_s` before passing, then `Date.parse` / `Time.zone.parse` inside the job.
- If passing an Active Record model through GlobalID, understand that perform-time lookup can fail if the record is gone and can observe changed state.
- **Write a round-trip test for every job** (enqueue → dequeue → perform) covering argument type fidelity. Date/Time and hash serialization bugs are easy to miss without exercising the real adapter path.

## Callback Enqueue Rules

- **`after_commit` + secondary responsibilities (notifications, audit, stats) → OK** — a Rails Core–endorsed pattern.
- **`after_create` / `after_save` (inside transaction): don't enqueue directly** — use `after_commit` when a callback needs to enqueue a secondary responsibility.
- **Primary business logic → Service layer**, not callbacks.
- See `rails-models.md` "Callbacks & Network I/O" and `async-external-calls.md` "Correct Usage of Callback Enqueuing."
