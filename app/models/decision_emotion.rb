class DecisionEmotion < ApplicationRecord
  belongs_to :decision
  belongs_to :emotion_type

  validates :recorded_on, presence: true
end
