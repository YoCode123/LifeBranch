class RemoveRecordedOnFromDecisionEmotions < ActiveRecord::Migration[8.1]
  def change
    remove_column :decision_emotions, :recorded_on, :date
  end
end
