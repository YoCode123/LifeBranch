class NotificationMailer < ApplicationMailer
  def reminder(user, decision)
    @user = user
    @decision = decision

    mail(
      to: @user.email,
      subject: "最近の決断を振り返ってみませんか？"
    )
  end
end
