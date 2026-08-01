class DecisionPatternAnalysisService
  def initialize(user)
    @user = user
  end

  def category_counts
    decisions
      .joins(:category)
      .group("categories.name")
      .count
  end

  private

  def decisions
    @user.decisions
  end
end
