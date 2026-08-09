class EmailNotificationJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.current

    User.where(email_notification_enabled: true).find_each do |user|
      next unless user.email_notification_time.strftime("%H:%M") == current_time.strftime("%H:%M")

      decision = user.decisions.order(created_at: :desc).first
      next unless decision

      NotificationMailer.reminder(user, decision).deliver_now
    end
  end
end
