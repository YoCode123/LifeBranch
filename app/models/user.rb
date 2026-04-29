class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  def first_login?
    sign_in_count <= 1
  end

  validates :name, presence: true, length: { maximum: 50 }
  has_many :decisions, dependent: :destroy
end
