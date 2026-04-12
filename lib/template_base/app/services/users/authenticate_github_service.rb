class Users::AuthenticateGithubService
  class Result < Data.define(:authenticated, :user, :failure_reason)
    def authenticated?
      authenticated
    end
  end

  def initialize(auth:)
    @auth = auth
  end

  def authenticate_user
    existing_user = User.find_by(provider: provider, uid: uid)
    return Result.new(authenticated: true, user: existing_user, failure_reason: nil) if existing_user.present?

    return Result.new(authenticated: false, user: nil, failure_reason: :missing_email) if email.blank?

    user = User.find_or_initialize_by(email: email)
    user.provider = provider
    user.uid = uid
    user.password = Devise.friendly_token.first(20) if user.encrypted_password.blank?
    assign_profile(user)

    if user.save
      Result.new(authenticated: true, user:, failure_reason: nil)
    else
      Result.new(authenticated: false, user:, failure_reason: :invalid_user)
    end
  end

  private

  attr_reader :auth

  def provider
    auth.provider
  end

  def uid
    auth.uid
  end

  def email
    auth.dig(:info, :email).to_s.strip.downcase.presence
  end

  def assign_profile(user)
    if auth.dig(:info, :first_name).present? || auth.dig(:info, :last_name).present?
      user.first_name = auth.dig(:info, :first_name).presence || user.first_name
      user.last_name = auth.dig(:info, :last_name).presence || user.last_name
    elsif auth.dig(:info, :name).present?
      user.name = auth.dig(:info, :name)
    end
  end
end
