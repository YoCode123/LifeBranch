class DecisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decision, only: [:show, :edit, :update, :destroy]
  before_action :set_emotion_types, only: [:new, :edit, :create, :update]

  def index
    @q = current_user.decisions.ransack(params[:q])

    @q.sorts = "created_at desc" if @q.sorts.empty?

    @decisions = @q
      .result(distinct: true)
      .page(params[:page])
      .per(3)
  end

  def show
    @decision = current_user.decisions.find(params[:id]).reload
  end

  def new
    @decision = Decision.new
    3.times { @decision.options.build }
  end

  def timeline
  @decisions = current_user.decisions
                           .includes(:category)
                           .order(recorded_on: :desc)
end



def create
  @decision = current_user.decisions.new(decision_params)

  selected_temp =
    params[:decision][:selected_option_temp]

  if @decision.save
    if selected_temp.present?
      index =
        selected_temp.to_s.gsub("new_", "").to_i

      selected_option =
        @decision.options[index]

      if selected_option.present?
        @decision.update(
          selected_option_id: selected_option.id
        )
      end
    end

    save_emotions

    redirect_to @decision,
      notice: "作成しました！"
  else
    build_options_if_empty

    render :new,
      status: :unprocessable_entity
  end
end

  def edit
    build_options_if_empty
  end

def update
  selected_temp =
    params[:decision][:selected_option_temp]

  if @decision.update(decision_params)

    save_emotions

    if selected_temp.present?

      if selected_temp.start_with?("new_")

        index =
          selected_temp.split("_").last.to_i

        new_option =
          @decision.options.order(:created_at)[index]

        @decision.update_column(
          :selected_option_id,
          new_option.id
        ) if new_option.present?

      else

        @decision.update_column(
          :selected_option_id,
          selected_temp
        )

      end
    end

    redirect_to @decision,
      notice: "更新しました！"

  else
    render :edit,
      status: :unprocessable_entity
  end
end


  def destroy
    Decision.transaction do
      @decision.update_column(:selected_option_id, nil)
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
      :reason,
      :recorded_on,
      emotion_type_ids: [],
      options_attributes: [:id, :content, :_destroy]
    )
  end

  def save_emotions
    emotion_ids = params.dig(:decision, :emotion_type_ids)&.reject(&:blank?)
    return if emotion_ids.blank?

    @decision.decision_emotions.destroy_all

    emotion_ids.each do |emotion_id|
      @decision.decision_emotions.create(emotion_type_id: emotion_id)
    end
  end
end
