class EmotionAnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    @emotion_counts = current_user.decisions
                                  .joins(:emotion_types)
                                  .group("emotion_types.name")
                                  .count
  end
end
