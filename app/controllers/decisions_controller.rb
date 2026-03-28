class DecisionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @decisions = current_user.decisions.order(created_at: :desc).limit(20)
  end
end
