class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]#, :confirmable

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_books, through: :bookmarks, source: :book

  enum sex: { man: 0, woman: 1, other: 2}
  enum notification: { one_day_ago: 1, two_day_ago: 2, three_day_ago: 3, four_day_ago: 4, five_day_ago: 5, six_day_ago: 6,
                       seven_day_ago: 7, eight_day_ago: 8, nine_day_ago: 9, ten_day_ago: 10 ,eleven_day_ago: 11, twelve_day_ago: 12,
                       thirteen_day_ago: 13, fourteen_day_ago: 14 }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
end