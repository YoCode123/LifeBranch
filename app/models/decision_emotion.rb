class DecisionEmotion < ApplicationRecord
  belongs_to :decision
  belongs_to :emotion_type
end
