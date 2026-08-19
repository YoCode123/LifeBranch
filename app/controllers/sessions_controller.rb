class SessionsController < ApplicationController
  def omniauth
    auth = request.env["omniauth.auth"]

    Rails.logger.debug "=== OAuth ==="
    Rails.logger.debug "provider: #{auth.provider}"
    Rails.logger.debug "uid: #{auth.uid}"
    Rails.logger.debug "email: #{auth.info.email}"

    user = User.from_omniauth(auth)

    sign_in user

    redirect_to dashboard_path, notice: "#{auth.provider}ログインに成功しました。"
  end

  def failure
    redirect_to root_path, alert: "ログインに失敗しました。"
  end
end
