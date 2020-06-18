class Book < ApplicationRecord
  has_many :book_details, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user

  def  bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end
end
