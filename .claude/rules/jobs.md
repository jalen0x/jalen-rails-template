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
- Use `deliver_later` for mailers in jobs — `deliver_now` blocks the worker.
- Use `perform_now` only when the current job depends on the result (e.g. upload must finish before video generation).
- Pass models to jobs, not IDs — ActiveJob serializes/deserializes via GlobalID automatically.

## Idempotency

Jobs get retried automatically. For **every line** in a job, ask: "if this line succeeds, the next line raises, and the entire job re-runs, what happens?" No double side effects (double charges, duplicate emails, double inventory deductions) = idempotent.

### Splitting Strategy

Don't pack multiple independent side effects into one job. Split into single-effect jobs:

```ruby
# Bad: one job with multiple steps; retry may send duplicate emails
PostWidgetCreationJob.perform_later(widget.id)

# Good: each job has a single side effect
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

- ActiveJob arguments go through JSON serialization: symbol keys become strings, DateTime loses its type.
- For Active Record objects, GlobalID handles serialization automatically (pass models, not IDs — already the convention in this project).
- For DateTime, explicitly `.to_s` before passing, then `Date.parse` inside the job.
- **Write a round-trip test for every job** (enqueue → dequeue → perform) covering argument type fidelity. The SR book author, with 8 years of Resque experience, still hit a DateTime serialization bug in his own book examples.

## Callback Enqueue Rules

- **`after_commit` + secondary responsibilities (notifications, audit, stats) → OK** — a Rails Core–endorsed pattern.
- **`after_create` / `after_save` (inside transaction) → ensure `enqueue_after_transaction_commit = true` is enabled** (default in Rails 8.2, manual in 8.1).
- **Primary business logic → Service layer**, not callbacks.
- See `rails-models.md` "Callbacks & Network I/O" and `async-external-calls.md` "Correct Usage of Callback Enqueuing."
