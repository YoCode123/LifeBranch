class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

 def after_sign_in_path_for(resource)
    if resource.first_login?
      flash[:notice] = "初回ログインおめでとうございます！"
      # 初回ログイン専用ページにリダイレクトしたい場合はここで指定
      # first_login_path
      resource.update(first_login: false)
    end

    super # 通常は元々のリダイレクト先
  end
end
