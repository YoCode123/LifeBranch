class AddReasonToDecisions < ActiveRecord::Migration[8.1]
  def change
    add_column :decisions, :reason, :text
  end
end
