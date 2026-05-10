class AddRecordedOnToDecisions < ActiveRecord::Migration[8.1]
  def change
    add_column :decisions, :recorded_on, :date
  end
end
