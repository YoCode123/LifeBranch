class AddDateToDecisionEmotions < ActiveRecord::Migration[8.1]
  def change
    add_column :decision_emotions, :recorded_on, :date
  end
end
