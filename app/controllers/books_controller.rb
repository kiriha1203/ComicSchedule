class BooksController < ApplicationController
  before_action :login_required
  before_action :go_admin
  before_action :change_layout
  PER = 20

  def index
    @books = Book.all.order(:title_kana)
    if params[:search].present?
      @books = @books.syllabary_like(params[:syllabary_search]).title_like(params[:title_search])
    end
    @books = @books.page(params[:page]).per(PER)
  end

  def show
    @book = Book.find(params[:id])
    @book_details = @book.book_details
  end

  def bookmarks_index
    @books = current_user.bookmark_books
  end

  private
  def book_params
    params.require(:book).permit(:title, :title_kana, :author, :label, :issue_from)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def change_layout
    render layout: 'admin_application' if current_user.admin?
  end

  def go_admin
    redirect_to admin_books_url if current_user.admin?
  end
end