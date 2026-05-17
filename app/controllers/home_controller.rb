class HomeController < ApplicationController
  def index
    @decisions =
      current_user.decisions
                  .order(Arel.sql("COALESCE(recorded_on, created_at) DESC"))
  end
end
