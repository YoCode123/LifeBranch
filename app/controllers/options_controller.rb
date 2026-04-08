class OptionsController < ApplicationController
  def create
    decision = Decision.find(params[:decision_id])

    option = decision.options.build(option_params)

    if option.save
      redirect_to decision_path(decision), notice: "Optionを追加しました"
    else
      redirect_to decision_path(decision), alert: "失敗しました"
    end
  end

  private

  def option_params
    params.require(:option).permit(:content)
  end
end
