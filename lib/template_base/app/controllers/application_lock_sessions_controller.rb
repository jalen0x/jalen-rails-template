class ApplicationLockSessionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :require_application_unlock
  before_action :enforce_unlock_attempt_limit, only: :create

  # GET /application_lock_session/new
  def new
    authorize :application_lock_session
    @application_lock = current_user.application_lock
  end

  # POST /application_lock_session
  def create
    authorize :application_lock_session
    @application_lock = current_user.application_lock

    if @application_lock.blank?
      redirect_to application_lock_path, alert: t(".not_enabled")
    elsif @application_lock.authenticate_pin(unlock_params[:pin])
      mark_application_unlocked
      login_attempt_limiter.reset(email: current_user.email, ip: request.remote_ip)
      redirect_to root_path, notice: t(".unlocked")
    else
      login_attempt_limiter.record_failure(email: current_user.email, ip: request.remote_ip)
      flash.now[:alert] = t(".invalid_pin")
      render :new, status: :unprocessable_content
    end
  end

  # DELETE /application_lock_session
  def destroy
    authorize :application_lock_session

    if !current_user.application_lock_enabled?
      redirect_to application_lock_path, alert: t(".not_enabled"), status: :see_other
    else
      clear_application_unlock
      redirect_to new_application_lock_session_path, notice: t(".locked"), status: :see_other
    end
  end

  private

  def enforce_unlock_attempt_limit
    return unless login_attempt_limiter.blocked?(email: current_user.email, ip: request.remote_ip)

    @application_lock = current_user.application_lock
    flash.now[:alert] = t("users.sessions.create.too_many_attempts")
    render :new, status: :too_many_requests
  end

  def login_attempt_limiter
    @login_attempt_limiter ||= LoginAttemptLimiter.new
  end

  def unlock_params
    params.expect(application_lock: [ :pin ])
  end
end
