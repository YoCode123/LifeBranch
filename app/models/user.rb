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

  has_one_attached :avatar
  has_many :decisions, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    return user if user

    user = find_by(email: auth.info.email)

    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid
      )

      return user
    end

    create!(
      email: auth.info.email,
      provider: auth.provider,
      uid: auth.uid,
      password: Devise.friendly_token[0, 20],
      name: auth.info.name.presence || "Googleユーザー"
    )
  end
end
