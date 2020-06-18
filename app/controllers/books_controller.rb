class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def bookmarks_index
    @books = current_user.bookmark_books.includes(:user)
  end
end