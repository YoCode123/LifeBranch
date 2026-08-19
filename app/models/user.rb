class User < ApplicationRecord
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
  has_many :oauth_accounts, dependent: :destroy

  def self.from_omniauth(auth)
    oauth_account = OauthAccount.find_by(
      provider: auth.provider,
      uid: auth.uid
    )

    return oauth_account.user if oauth_account

    user = find_by(email: auth.info.email)

    if user
      user.oauth_accounts.create!(
        provider: auth.provider,
        uid: auth.uid
      )

      return user
    end

    user = create!(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      name: auth.info.name.presence || "OAuthユーザー"
    )

    user.oauth_accounts.create!(
      provider: auth.provider,
      uid: auth.uid
    )

    user
  end
end
