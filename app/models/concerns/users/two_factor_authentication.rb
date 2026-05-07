module Users::TwoFactorAuthentication
  extend ActiveSupport::Concern

  def disable_two_factor_authentication!
    update!(
      otp_required_for_login: false,
      otp_secret: nil,
      consumed_timestep: nil,
      otp_backup_codes: []
    )
  end
end
