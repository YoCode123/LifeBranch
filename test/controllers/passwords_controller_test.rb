require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "should get sent" do
    get passwords_sent_url
    assert_response :success
  end
end
