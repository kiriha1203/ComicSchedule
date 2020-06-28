class Book < ApplicationRecord
  require 'nkf'

  has_many :book_details, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user

  validates :title, presence: true

  def  bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  scope :syllabary_like, -> (syllabary_search) do
    next if syllabary_search.blank?
    where("books.title_kana LIKE ?", "#{syllabary_search}%")
  end

  scope :title_like, -> (title_search) do
    next if title_search.blank?
    title_kana_search = NKF.nkf('-w -X', title_search).tr("A-Za-z0-9","Ａ-Ｚａ-ｚ０-９").tr('ァ-ン','ぁ-ん')
    where( "books.title LIKE ?" , "%#{title_search}%").or(where("books.title_kana LIKE ?", "%#{title_kana_search}%") )
  end

end