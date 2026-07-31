class EmotionAnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    analysis = EmotionAnalysisService.new(current_user)

    @emotion_counts = analysis.emotion_counts
    @total_emotions = analysis.total_emotions
    @most_emotion = analysis.most_emotion
    @monthly_emotions = analysis.monthly_emotions
    @category_emotions = analysis.category_emotions

    @category_chart_data = @category_emotions.map do |(category, emotion), count|
      ["#{category}（#{emotion}）", count]
    end
  end
end
