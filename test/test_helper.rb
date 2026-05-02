ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "support/confidence_check"

Capybara.configure do |config|
  config.test_id = "data-testid"
end

module ActiveSupport
  class TestCase
    include TestSupport::ConfidenceCheck

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end
