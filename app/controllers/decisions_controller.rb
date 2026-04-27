class DecisionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @decisions = current_user.decisions.order(created_at: :desc)
  end

  def show
    @decision = current_user.decisions.find(params[:id])
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
      redirect_to @decision
    else
      3.times { @decision.options.build } if @decision.options.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @decision = current_user.decisions.find(params[:id])
    @decision.options.build if @decision.options.empty?
  end

  def update
    @decision = current_user.decisions.find(params[:id])

    if @decision.update(decision_params)
      assign_selected_option
      redirect_to decision_path(@decision), notice: "更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @decision = current_user.decisions.find(params[:id])

    Decision.transaction do
      @decision.update_columns(selected_option_id: nil)
      @decision.destroy
    end

    redirect_to decisions_path, notice: "削除しました！"
  end

  private

  def decision_params
    params.require(:decision).permit(
      :title,
      :category_id,
      :selected_option_id,
      :reason,
      options_attributes: [:id, :content, :_destroy],
      emotion_type_ids: []
    )
  end

  def assign_selected_option
    return unless params[:decision][:selected_option_index].present?

    index = params[:decision][:selected_option_index].to_i
    option = @decision.options[index]

    @decision.update_column(:selected_option_id, option&.id)
  end
end
