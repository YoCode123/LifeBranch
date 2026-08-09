require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "reminder" do
    user = users(:one)

    email = NotificationMailer.reminder(user)

    assert_equal ["test1@example.com"], email.to
    assert_equal ["from@example.com"], email.from
    assert_equal "LifeBranchからのお知らせ", email.subject
  end
end
