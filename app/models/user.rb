class User < ApplicationRecord
  include Users::Authenticatable, Users::Profile, Users::SoftDelete, Users::TwoFactorAuthentication

  has_many :two_factor_recovery_codes, dependent: :destroy
  has_one :two_factor_authentication, dependent: :destroy
  has_one :application_lock, dependent: :destroy

  def two_factor_enabled? = two_factor_authentication.present?

  def application_lock_enabled?
    ApplicationLock.exists?(user_id: id)
  end
end
