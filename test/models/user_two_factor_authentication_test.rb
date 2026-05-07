require "test_helper"

class UserTwoFactorAuthenticationTest < ActiveSupport::TestCase
  test "authenticator app code can be consumed once" do
    user = FactoryBot.create(:user)
    user.otp_secret = User.generate_otp_secret
    user.otp_required_for_login = true
    user.save!

    code = user.current_otp

    assert user.validate_and_consume_otp!(code)
    refute user.validate_and_consume_otp!(code)
  end

  test "backup code can be consumed once" do
    user = FactoryBot.create(:user)
    user.otp_secret = User.generate_otp_secret
    user.otp_required_for_login = true
    backup_code = user.generate_otp_backup_codes!.first
    user.save!

    assert user.invalidate_otp_backup_code!(backup_code)
    refute user.invalidate_otp_backup_code!(backup_code)
  end

  test "disabling two factor authentication clears stored second factor data" do
    user = FactoryBot.create(:user)
    user.otp_secret = User.generate_otp_secret
    user.consumed_timestep = 123
    user.otp_required_for_login = true
    user.generate_otp_backup_codes!
    user.save!

    user.disable_two_factor_authentication!

    refute user.otp_required_for_login?
    assert_nil user.otp_secret
    assert_nil user.consumed_timestep
    assert_empty user.otp_backup_codes
  end
end
