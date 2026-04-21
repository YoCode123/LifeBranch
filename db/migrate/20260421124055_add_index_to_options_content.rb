class AddIndexToOptionsContent < ActiveRecord::Migration[8.1]
  def change
    add_index :options, [:decision_id, :content], unique: true
  end
end
