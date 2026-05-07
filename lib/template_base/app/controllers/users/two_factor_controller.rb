class Users::TwoFactorController < ApplicationController
  before_action :authenticate_user!

  def new
    return redirect_to edit_user_registration_path if current_user.otp_required_for_login?

    prepare_setup
  end

  def create
    prepare_setup

    if current_user.validate_and_consume_otp!(params[:second_factor_code], otp_secret: @setup_secret)
      current_user.otp_secret = @setup_secret
      current_user.otp_required_for_login = true
      @backup_codes = current_user.generate_otp_backup_codes!
      current_user.save!
      session.delete(:two_factor_setup_secret)
      render :backup_codes
    else
      flash.now[:alert] = t(".invalid_second_factor_code")
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    current_user.disable_two_factor_authentication!
    redirect_to edit_user_registration_path, status: :see_other, notice: t(".disabled")
  end

  private

  def prepare_setup
    @setup_secret = session[:two_factor_setup_secret] ||= User.generate_otp_secret
    current_user.otp_secret = @setup_secret
    @provisioning_uri = current_user.otp_provisioning_uri(
      current_user.email,
      issuer: TemplateBase.config.application_name
    )
    @qr_code_svg = RQRCode::QRCode.new(@provisioning_uri).as_svg(
      module_size: 4,
      standalone: true,
      use_path: true,
      viewbox: true
    )
  end
end
