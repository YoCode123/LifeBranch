class EmailNotificationJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.current

    User.where(email_notification_enabled: true).find_each do |user|
      next unless user.email_notification_time.strftime("%H:%M") == current_time.strftime("%H:%M")

      NotificationMailer.reminder(user).deliver_now
    end
  end
end
