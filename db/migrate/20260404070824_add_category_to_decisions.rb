class AddCategoryToDecisions < ActiveRecord::Migration[8.1]
  def change
    add_reference :decisions, :category, foreign_key: true
  end
end
