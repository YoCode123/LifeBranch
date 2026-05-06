class GuidesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def complete
    current_user.update(first_login_done: true)
    redirect_to new_decision_path
  end
end
