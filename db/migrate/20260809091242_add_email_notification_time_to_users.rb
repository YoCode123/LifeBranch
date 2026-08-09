class AddEmailNotificationTimeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_notification_time, :time, default: "08:00", null: false
  end
end
