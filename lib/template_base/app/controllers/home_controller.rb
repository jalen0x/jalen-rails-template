class HomeController < ApplicationController
  def show
    return unless preview_toast?

    flash.now[:manual_preview_toast] = {
      message: "Dismiss this toast manually.",
      variant: :success,
      dismissable: true
    }

    return if params[:dismiss_after].blank?

    flash.now[:auto_preview_toast] = {
      message: "Preview toast from the template base.",
      variant: :info,
      dismissable: false,
      dismiss_after: params[:dismiss_after].to_i
    }
  end

  private

  def preview_toast?
    return false unless Rails.env.development? || Rails.env.test?

    params[:toast_preview].present?
  end
end
