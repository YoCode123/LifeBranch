class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :decision_emotions, dependent: :destroy
  has_many :emotion_types, through: :decision_emotions
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true
end
