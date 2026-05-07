class GuidesController < ApplicationController

  def show
    redirect_to dashboard_path if user_signed_in?
  end

  def complete
    current_user.update(first_login_done: true)
    redirect_to new_decision_path
  end
end
