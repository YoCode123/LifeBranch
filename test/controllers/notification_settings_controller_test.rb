require "test_helper"

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get notification_settings_edit_url
    assert_response :success
  end

  test "should get update" do
    get notification_settings_update_url
    assert_response :success
  end
end
