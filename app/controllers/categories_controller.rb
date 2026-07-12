class CategoriesController < ApplicationController
  def search
    categories =
      if params[:keyword].present?
        Category.where(
          "name LIKE ?",
          "%#{params[:keyword]}%"
        )
      else
        Category.all
      end

    render json: categories
  end
end
