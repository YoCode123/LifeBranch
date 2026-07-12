class CategoriesController < ApplicationController
  def search
    categories = Category.where(
      "name LIKE ?",
      "%#{params[:keyword]}%"
    )

    render json: categories
  end
end
