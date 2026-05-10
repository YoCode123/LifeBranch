class DecisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decision, only: [:show, :edit, :update, :destroy]
  before_action :set_emotion_types, only: [:new, :edit, :create, :update]

  def index
    @decisions = current_user.decisions.order(created_at: :desc)
  end

  def show
    @options = @decision.options
  end

  def new
    @decision = Decision.new
    3.times { @decision.options.build }
  end

  def create
    @decision = current_user.decisions.new(decision_params)

    if @decision.save
      assign_selected_option
      save_emotions
      redirect_to @decision, notice: "作成しました！"
    else
      build_options_if_empty
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_options_if_empty
  end

  def update
    if @decision.update(decision_params)
      assign_selected_option
      save_emotions
      redirect_to @decision, notice: "更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Decision.transaction do
      @decision.update_columns(selected_option_id: nil)
      @decision.destroy
    end

    redirect_to decisions_path, notice: "削除しました！"
  end

  private

  def set_decision
    @decision = current_user.decisions.find(params[:id])
  end

  def set_emotion_types
    @emotion_types = EmotionType.all
  end

  def build_options_if_empty
    return if @decision.options.any?

    3.times { @decision.options.build }
  end

  def decision_params
    params.require(:decision).permit(
      :title,
      :category_id,
      :selected_option_id,
      :reason,
      :recorded_on,
      emotion_type_ids: [],
      options_attributes: [:id, :content, :_destroy]
    )
  end

  def assign_selected_option
    index = params.dig(:decision, :selected_option_index)
    return if index.blank?

    option = @decision.options[index.to_i]
    return if option.nil?

    @decision.update_column(:selected_option_id, option.id)
  end

def save_emotions
  emotion_ids = params.dig(:decision, :emotion_type_ids)&.reject(&:blank?)
  return if emotion_ids.blank?

  @decision.decision_emotions.destroy_all

  emotion_ids.each do |emotion_id|
    @decision.decision_emotions.create(
      emotion_type_id: emotion_id
    )
  end
end
end
