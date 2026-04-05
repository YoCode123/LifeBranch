class Option < ApplicationRecord
  belongs_to :decision

  validates :content, presence: true
end
