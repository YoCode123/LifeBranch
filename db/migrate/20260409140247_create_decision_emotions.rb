class CreateDecisionEmotions < ActiveRecord::Migration[8.1]
  def change
    create_table :decision_emotions do |t|
      t.references :decision, null: false, foreign_key: true
      t.references :emotion_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
