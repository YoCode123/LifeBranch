class Category < ApplicationRecord
  has_many :decisions

  validates :name, presence: true, uniqueness: true
end
