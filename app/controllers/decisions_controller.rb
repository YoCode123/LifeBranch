class DecisionsController < ApplicationController
  def index
    @decisions = current_user.decisions
  end
end
