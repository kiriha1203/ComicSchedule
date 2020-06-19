class BooksController < ApplicationController
  before_action :login_required
  before_action :change_layout

  def index
    @books = Book.all.order(:title_kana)
    if params[:search].present?
      @books = @books.title_like(params[:title_search])
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def bookmarks_index
    @books = current_user.bookmark_books
  end

  private
  def change_layout
    if current_user.admin?
      render layout: 'admin_application'
    end
  end
end