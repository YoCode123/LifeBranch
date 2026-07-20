class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @decisions = current_user.decisions
                             .order(Arel.sql("COALESCE(recorded_on, created_at) DESC"))

    @emotion_chart = current_user.decisions
                                 .joins(:emotion_types)
                                 .group("emotion_types.name")
                                 .count

    @decision_count = current_user.decisions.count
    @most_emotion = @emotion_chart.max_by { |_, count| count }
  end
end
