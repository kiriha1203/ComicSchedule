class Book < ApplicationRecord
  has_many :book_details, dependent: :destroy
end
