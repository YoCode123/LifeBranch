require "test_helper"

class EmotionAnalysisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get emotion_analysis_index_url
    assert_response :success
  end
end
