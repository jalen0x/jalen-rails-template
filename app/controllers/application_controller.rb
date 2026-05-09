class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :require_application_unlock
  helper_method :application_lock_unlocked?, :application_lock_unlocked_or_disabled?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def require_application_unlock
    user = warden.user(:user)
    return if user.blank?
    return unless user.application_lock_enabled?
    return if application_lock_unlocked?

    redirect_to new_application_lock_session_path, alert: t("application_locks.locked_alert")
  end

  def application_lock_unlocked?
    session[:application_lock_unlocked_user_id] == warden.user(:user)&.id
  end

  def application_lock_unlocked_or_disabled?
    return true unless user_signed_in?
    return true unless current_user.application_lock_enabled?

    application_lock_unlocked?
  end

  def mark_application_unlocked
    session[:application_lock_unlocked_user_id] = current_user.id
  end

  def clear_application_unlock
    session.delete(:application_lock_unlocked_user_id)
  end
end
