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

  def decision_count
    decisions.count
  end

  def most_category
    category_counts.max_by { |_, count| count }
  end

  private

  def decisions
    @user.decisions
  end
end
