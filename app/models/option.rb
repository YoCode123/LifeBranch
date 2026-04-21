class Option < ApplicationRecord
  belongs_to :decision

  validates :content, presence: true, length: { maximum: 100 }
  validates :content, uniqueness: { scope: :decision_id }
end
