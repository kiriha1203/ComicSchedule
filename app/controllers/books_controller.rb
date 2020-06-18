class BooksController < ApplicationController
  before_action :login_required
  before_action :change_layout

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def bookmarks_index
    @books = current_user.bookmark_books.includes(:user)
  end

  private
  def change_layout
    if current_user.admin?
      render layout: 'admin_application'
    end
  end
end