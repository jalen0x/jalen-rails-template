module Users::Authenticatable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :omniauthable, omniauth_providers: [ :github ]
  end

  class_methods do
    # Finds or creates a User from an OmniAuth callback.
    # Pass the full auth hash (request.env["omniauth.auth"]).
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name if auth.info.name.present?
      end
    end
  end
end
