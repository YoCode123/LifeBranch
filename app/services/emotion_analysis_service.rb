class EmotionAnalysisService
  def initialize(user)
    @user = user
  end

  def emotion_counts
    decisions
      .joins(:emotion_types)
      .group("emotion_types.name")
      .count
  end

  def total_emotions
    emotion_counts.values.sum
  end

  def most_emotion
    emotion_counts.max_by { |_, count| count }
  end

  def monthly_emotions
    decisions
      .joins(:emotion_types)
      .where.not(recorded_on: nil)
      .group_by_month(:recorded_on, format: "%Y-%m")
      .count
  end

  def category_emotions
    decisions
      .joins(:category, :decision_emotions, :emotion_types)
      .group("categories.name", "emotion_types.name")
      .count
  end

  private

  def decisions
    @user.decisions
  end
end
