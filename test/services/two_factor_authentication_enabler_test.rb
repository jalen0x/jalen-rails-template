require "test_helper"

class TwoFactorAuthenticationEnablerTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user, password: "password123")
    @secret = TwoFactorAuthentication.generate_secret
  end

  test "enables 2FA and issues recovery codes when password and OTP match" do
    result = TwoFactorAuthenticationEnabler.new.enable(
      user: @user,
      current_password: "password123",
      otp_code: ROTP::TOTP.new(@secret).now,
      otp_secret: @secret
    )

    assert_predicate result, :enabled?
    assert @user.reload.two_factor_enabled?
    assert_predicate result.two_factor_authentication, :persisted?
    assert_equal TwoFactorRecoveryCodeGenerator::CODE_COUNT, result.recovery_codes.size
  end

  test "rejects with :invalid_password when current password is wrong" do
    result = TwoFactorAuthenticationEnabler.new.enable(
      user: @user,
      current_password: "wrong",
      otp_code: ROTP::TOTP.new(@secret).now,
      otp_secret: @secret
    )

    refute_predicate result, :enabled?
    assert_equal :invalid_password, result.error
    refute @user.reload.two_factor_enabled?
  end

  test "rejects with :invalid_otp when verification code is wrong" do
    result = TwoFactorAuthenticationEnabler.new.enable(
      user: @user,
      current_password: "password123",
      otp_code: "000000",
      otp_secret: @secret
    )

    refute_predicate result, :enabled?
    assert_equal :invalid_otp, result.error
    refute @user.reload.two_factor_enabled?
  end

  test "rejects with :invalid_setup when otp_secret is blank" do
    result = TwoFactorAuthenticationEnabler.new.enable(
      user: @user,
      current_password: "password123",
      otp_code: "123456",
      otp_secret: nil
    )

    refute_predicate result, :enabled?
    assert_equal :invalid_setup, result.error
  end

  test "the OTP used to enable cannot be replayed afterwards" do
    code = ROTP::TOTP.new(@secret).now
    TwoFactorAuthenticationEnabler.new.enable(
      user: @user,
      current_password: "password123",
      otp_code: code,
      otp_secret: @secret
    )

    refute @user.reload.two_factor_authentication.verify_otp(code),
           "Setup OTP should be marked consumed and unable to verify again"
  end
end
