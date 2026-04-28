class DecisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decision, only: [:show, :edit, :update, :destroy]
  before_action :set_emotion_types, only: [:new, :create, :edit, :update]

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
      save_emotions_with_date
      redirect_to @decision
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
      save_emotions_with_date
      redirect_to decision_path(@decision), notice: "更新しました！"
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
    3.times { @decision.options.build } if @decision.options.empty?
  end

  def decision_params
    params.require(:decision).permit(
      :title,
      :category_id,
      :selected_option_id,
      :reason,
      options_attributes: [:id, :content, :_destroy]
    )
  end

  def assign_selected_option
    return unless params.dig(:decision, :selected_option_index).present?

    index = params[:decision][:selected_option_index].to_i
    option = @decision.options[index]

    @decision.update_column(:selected_option_id, option&.id)
  end

def save_emotions_with_date
  emotion_ids = params.dig(:decision, :emotion_type_ids)&.reject(&:blank?)
  recorded_on_param = params.dig(:decision, :recorded_on)

  return if recorded_on_param.blank?

  recorded_on = begin
    Date.parse(recorded_on_param)
  rescue
    nil
  end

  return if recorded_on.nil?

  @decision.decision_emotions.destroy_all

  if emotion_ids.present?
    emotion_ids.each do |emotion_id|
      @decision.decision_emotions.create(
        emotion_type_id: emotion_id,
        recorded_on: recorded_on
      )
    end
  end
end
end
