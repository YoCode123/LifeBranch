class EmotionAnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    @emotion_counts = current_user.decisions
                                  .joins(:emotion_types)
                                  .group("emotion_types.name")
                                  .count

    @total_emotions = @emotion_counts.values.sum
    @most_emotion = @emotion_counts.max_by { |_, count| count }

    @monthly_emotions = current_user.decisions
                                    .joins(:emotion_types)
                                    .where.not(recorded_on: nil)
                                    .group_by_month(:recorded_on, format: "%Y-%m")
                                    .count
  end
end
