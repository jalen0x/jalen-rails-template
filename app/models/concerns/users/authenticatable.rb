module Users::Authenticatable
  extend ActiveSupport::Concern

  included do
    devise :two_factor_authenticatable, :two_factor_backupable, :registerable,
           :recoverable, :rememberable, :validatable,
           :omniauthable, omniauth_providers: [ :github ]
  end
end
