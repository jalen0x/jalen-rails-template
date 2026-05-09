require "test_helper"

class FilterParameterLoggingTest < ActiveSupport::TestCase
  setup do
    @filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  end

  test "filters credentials, OTP, PIN, and digest parameters" do
    sample = {
      "user" => { "email" => "u@example.com", "password" => "secret" },
      "two_factor_authentication" => { "otp_code" => "123456", "current_password" => "x" },
      "two_factor_challenge" => { "otp_code" => "654321" },
      "application_lock" => { "pin" => "246810", "pin_confirmation" => "246810", "current_password" => "y" }
    }

    filtered = @filter.filter(sample)

    refute_includes filtered.to_s, "secret"
    refute_includes filtered.to_s, "123456"
    refute_includes filtered.to_s, "654321"
    refute_includes filtered.to_s, "246810"
  end
end
