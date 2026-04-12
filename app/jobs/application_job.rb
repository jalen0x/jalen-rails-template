class ApplicationJob < ActiveJob::Base
  # Defer job enqueuing until the current transaction commits.
  # Prevents race conditions where a worker picks up a job before the record is committed.
  # This becomes the default in Rails 8.2.
  self.enqueue_after_transaction_commit = true

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
