class SessionsController < ApplicationController
  def omniauth
    auth = request.env["omniauth.auth"]

    user = User.from_omniauth(auth)

    sign_in user
    redirect_to dashboard_path, notice: "Googleログインに成功しました。"
  end

  def failure
    redirect_to root_path, alert: "Googleログインに失敗しました。"
  end
end
