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

  def total_decisions
    decisions.count
  end

  def decision_counts_by_month
    decisions
      .where.not(recorded_on: nil)
      .group_by_month(:recorded_on, format: "%Y-%m")
      .count
  end

  private

  def decisions
    @user.decisions
  end
end
