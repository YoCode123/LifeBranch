class NotificationMailer < ApplicationMailer
  def reminder(user)
    @user = user

    mail(
      to: @user.email,
      subject: "LifeBranchからのお知らせ"
    )
  end
end
