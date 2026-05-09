class TwoFactorAuthentication < ApplicationRecord
  ISSUER = TemplateBase.config.application_name

  belongs_to :user

  validates :user_id, uniqueness: true
  validates :otp_secret, :enabled_at, presence: true

  def self.generate_secret
    ROTP::Base32.random_base32
  end

  def provisioning_uri
    totp.provisioning_uri(user.email)
  end

  def verify_otp(code)
    return false if code.blank?
    return false if otp_secret.blank?

    return perform_otp_verification(code) unless persisted?

    with_lock { perform_otp_verification(code) }
  rescue ROTP::Base32::Base32Error
    false
  end

  def as_json(_options = {})
    {
      enabled: true,
      enabled_at: enabled_at.iso8601(3)
    }
  end

  private

  # Caller must hold a row lock when self is persisted; otherwise two concurrent
  # requests could verify the same OTP timestep before either persists last_otp_at.
  def perform_otp_verification(code)
    timestamp = totp.verify(
      code.to_s.delete(" "),
      drift_behind: 30,
      drift_ahead: 30,
      after: last_otp_at&.to_i
    )
    return false unless timestamp

    self.last_otp_at = Time.zone.at(timestamp)
    save! if persisted?
    true
  end

  def totp
    ROTP::TOTP.new(otp_secret, issuer: ISSUER)
  end
end
