class Book < ApplicationRecord
  require 'nkf'

  has_many :book_details, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user

  def  bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  scope :title_like, -> (title_search) do
    next if title_search.blank?
    NKF.nkf('-w -X', title_search).tr("A-Za-z0-9","Ａ-Ｚａ-ｚ０-９").tr('あ-ん', 'ア-ン')
    where("books.title LIKE ?", "#{title_search}%") and where("books.title_kana LIKE ?", "#{title_search}%")
  end

end
