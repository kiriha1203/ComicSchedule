class Admin::BooksController < ApplicationController
  before_action :require_admin
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to admin_books_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to admin_book_url, success: "タスク「#{@book.title}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to admin_books_path, success: "タスク「#{@book.title}」を削除しました。"
  end

  private

  def book_params
    params.require(:book).permit(:title, :title_kana, :author, :label, :issue_from)
  end

  def set_book
    @book = Book.find(params[:id])
  end

end
