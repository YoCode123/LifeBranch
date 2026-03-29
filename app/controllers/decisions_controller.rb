# app/controllers/decisions_controller.rb
class DecisionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @decisions = current_user.decisions.order(created_at: :desc)
  end

  def show
    @decision = current_user.decisions.find(params[:id])
  end

  def new
    @decision = Decision.new
  end

  def create
    @decision = current_user.decisions.build(decision_params)

    if @decision.save
      redirect_to decisions_path, notice: "決断を作成しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def decision_params
    params.require(:decision).permit(:title)
  end
end
