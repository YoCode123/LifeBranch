class DecisionsController < ApplicationController
  after_action :verify_authorized, except: %i[index timeline]
  after_action :verify_policy_scoped, only: %i[index timeline]

  before_action :authenticate_user!
  before_action :set_decision, only: %i[show edit update destroy]
  before_action :set_emotion_types, only: %i[new edit create update]

  def index
    @q = policy_scope(Decision).ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?

    @decisions = @q
                   .result(distinct: true)
                   .includes(:category, :emotion_types)
                   .page(params[:page])
                   .per(3)
  end

  def show
  end

  def new
    @decision = Decision.new
    authorize @decision

    3.times { @decision.options.build }
  end

  def timeline
    @decisions = policy_scope(Decision)
                   .includes(:category)
                   .order(
                     recorded_on: :desc,
                     created_at: :desc
                   )
  end

  def create
    @decision = current_user.decisions.new(decision_params)
    authorize @decision

    selected_temp = params.dig(
      :decision,
      :selected_option_temp
    )

    if @decision.save
      save_selected_option(selected_temp)
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
    selected_temp = params.dig(
      :decision,
      :selected_option_temp
    )

    # 更新前に既存の選択肢IDを保存
    existing_option_ids = @decision.options.pluck(:id)

    if @decision.update(decision_params)

      save_selected_option(
        selected_temp,
        existing_option_ids
      )

      save_emotions

      redirect_to @decision, notice: "更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Decision.transaction do
      @decision.update_column(
        :selected_option_id,
        nil
      )

      @decision.destroy
    end

    redirect_to decisions_path, notice: "削除しました！"
  end

  private

  def set_decision
    @decision = Decision.find(params[:id])
    authorize @decision
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
      options_attributes: [
        :id,
        :content,
        :_destroy
      ]
    )
  end

  # 最終決断を保存する
  def save_selected_option(selected_temp, existing_option_ids = [])
    # 未選択
    if selected_temp.blank?
      @decision.update_column(
        :selected_option_id,
        nil
      )

      return
    end

    selected_temp = selected_temp.to_s

    # =====================================
    # 既存の選択肢
    # =====================================
    unless selected_temp.start_with?("new_")
      selected_option = @decision.options.find_by(
        id: selected_temp
      )

      if selected_option.present?
        @decision.update_column(
          :selected_option_id,
          selected_option.id
        )
      else
        # 選択されていた選択肢が削除された場合
        @decision.update_column(
          :selected_option_id,
          nil
        )
      end

      return
    end

    # =====================================
    # 新しく追加された選択肢
    # =====================================

    # new_0 / new_1 など
    index = selected_temp.sub("new_", "").to_i

    # 更新後の選択肢から、
    # 更新前には存在しなかったものだけ取得
    new_options = @decision.options
                           .where.not(id: existing_option_ids)
                           .order(:id)

    new_option = new_options[index]

    if new_option.present?
      @decision.update_column(
        :selected_option_id,
        new_option.id
      )
    else
      # 対応する選択肢が存在しない場合
      @decision.update_column(
        :selected_option_id,
        nil
      )
    end
  end

  def save_emotions
    emotion_ids = params
                    .dig(:decision, :emotion_type_ids)
                    &.reject(&:blank?)

    return if emotion_ids.blank?

    @decision.decision_emotions.destroy_all

    emotion_ids.each do |emotion_id|
      @decision.decision_emotions.create(
        emotion_type_id: emotion_id
      )
    end
  end
end
