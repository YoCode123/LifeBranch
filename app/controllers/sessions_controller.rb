class SessionsController < ApplicationController
  def omniauth
    auth = request.env["omniauth.auth"]

    Rails.logger.debug "=== OAuth ==="
    Rails.logger.debug "provider: #{auth.provider}"
    Rails.logger.debug "uid: #{auth.uid}"
    Rails.logger.debug "email: #{auth.info.email}"

    user = User.from_omniauth(auth)

    sign_in user

    provider_name =
      case auth.provider
      when "google_oauth2"
        "Google"
      when "github"
        "GitHub"
      else
        auth.provider
      end

    redirect_to dashboard_path, notice: "#{provider_name}ログインに成功しました。"
  end

  def failure
    redirect_to root_path, alert: "ログインに失敗しました。"
  end
end
