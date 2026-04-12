class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    result = Users::GithubAuthenticator.new(auth: request.env["omniauth.auth"]).authenticate

    if result.authenticated?
      flash[:github_success] = {
        message: t("users.omniauth_callbacks.github.success"),
        variant: :success,
        dismiss_after: 5_000
      }
      sign_in_and_redirect result.user, event: :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to root_path, alert: failure_message_for(result.failure_reason)
    end
  end

  def failure
    redirect_to root_path, alert: t("users.omniauth_callbacks.failure")
  end

  private

  def failure_message_for(reason)
    case reason
    when :missing_email
      t("users.omniauth_callbacks.github.missing_email")
    else
      t("users.omniauth_callbacks.github.invalid_user")
    end
  end
end
