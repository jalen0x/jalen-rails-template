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
