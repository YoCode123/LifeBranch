require "test_helper"

class DecisionPatternAnalysisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decision_pattern_analysis_index_url
    assert_response :success
  end
end
