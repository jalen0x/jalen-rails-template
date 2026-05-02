module TestSupport
  module ConfidenceCheck
    class ConfidenceCheckFailed < Minitest::Assertion
      def initialize(assertion)
        super("CONFIDENCE CHECK FAILED: #{assertion.message}")
        @assertion = assertion
      end

      delegate :backtrace,
        :error,
        :location,
        :result_code,
        :result_label,
        :backtrace_locations,
        :cause,
        to: :@assertion
    end

    def confidence_check(&block)
      block.call
    rescue Minitest::Assertion => error
      raise ConfidenceCheckFailed.new(error)
    end
  end
end
