class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, presence: true, length: { maximum: 100 }
end
