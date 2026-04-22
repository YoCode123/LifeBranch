class AddSelectedOptionToDecisions < ActiveRecord::Migration[8.1]
  def change
    add_reference :decisions, :selected_option, foreign_key: { to_table: :options }
  end
end
