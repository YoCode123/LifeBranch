class DecisionEmotion < ApplicationRecord
  belongs_to :decision
  belongs_to :emotion_type

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "decision_id", "emotion_type_id", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["decision", "emotion_type"]
  end
end
