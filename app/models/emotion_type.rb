class EmotionType < ApplicationRecord
  has_many :decision_emotions, dependent: :destroy
  has_many :decisions, through: :decision_emotions
  validates :name, presence: true, uniqueness: true
end
