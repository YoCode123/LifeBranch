class DecisionPatternAnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    analysis = DecisionPatternAnalysisService.new(current_user)

    @category_counts = analysis.category_counts
  end
end
