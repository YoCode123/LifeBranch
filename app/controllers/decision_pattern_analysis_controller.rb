class DecisionPatternAnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
  analysis = DecisionPatternAnalysisService.new(current_user)

  @category_counts = analysis.category_counts
  @decision_count = analysis.total_decisions
  @decision_counts = analysis.decision_counts_by_month
  @most_category = @category_counts.max_by { |_, count| count }
 end
end
