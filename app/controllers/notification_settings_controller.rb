class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(notification_settings_params)
      redirect_to notification_settings_path,
                  notice: "通知設定を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def notification_settings_params
    params.require(:user).permit(
      :email_notification_enabled,
      :email_notification_time
    )
  end
end
