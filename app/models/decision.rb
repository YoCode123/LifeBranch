class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :options, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true
end
