class Users::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  prepend_before_action :authenticate_with_second_factor, only: :create

  def new_second_factor
    if session[:second_factor_user_id].present?
      self.resource = resource_class.new
      render "devise/sessions/two_factor"
    else
      redirect_to new_user_session_path, alert: t("users.sessions.new_second_factor.missing_challenge")
    end
  end

  private

  def authenticate_with_second_factor
    if params.key?(:second_factor_code)
      authenticate_second_factor_attempt
    elsif sign_in_params[:email].present?
      self.resource = resource_class.find_for_database_authentication(email: sign_in_params[:email])
      clear_second_factor_challenge
      start_second_factor_challenge if resource&.otp_required_for_login?
    end
  end

  def start_second_factor_challenge
    return unless resource.valid_password?(sign_in_params[:password])

    session[:remember_me] = Devise::TRUE_VALUES.include?(sign_in_params[:remember_me])
    session[:second_factor_user_id] = resource.id
    render "devise/sessions/two_factor", status: :unprocessable_content
  end

  def authenticate_second_factor_attempt
    return redirect_to new_user_session_path, alert: t("users.sessions.new_second_factor.missing_challenge") if session[:second_factor_user_id].blank?

    self.resource = resource_class.find(session[:second_factor_user_id])

    if valid_second_factor_code?
      remember_me_enabled = session.delete(:remember_me)
      clear_second_factor_challenge
      remember_me(resource) if remember_me_enabled
      sign_in(resource, event: :authentication)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = t(".invalid_second_factor_code")
      render "devise/sessions/two_factor", status: :unprocessable_content
    end
  end

  def valid_second_factor_code?
    code = params[:second_factor_code].to_s.strip

    resource.validate_and_consume_otp!(code) || resource.invalidate_otp_backup_code!(code)
  end

  def clear_second_factor_challenge
    session.delete(:second_factor_user_id)
  end
end
