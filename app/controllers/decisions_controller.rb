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
  end

  def create
    @decision = current_user.decisions.build(decision_params)

    if @decision.save
      redirect_to decisions_path, notice: "Decisionを作成しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @decision = current_user.decisions.find(params[:id])
  end

  def update
    @decision = current_user.decisions.find(params[:id])

    if @decision.update(decision_params)
      redirect_to decision_path(@decision), notice: "更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @decision = current_user.decisions.find(params[:id])
    @decision.destroy

    redirect_to decisions_path, notice: "削除しました！"
  end

  private

  def decision_params
    params.require(:decision).permit(:title, :category_id)
  end
end
