class Admin::BookDetailsController < ApplicationController
  before_action :require_admin
  before_action :set_book_detail, only: [:show, :edit, :update, :destroy]

  layout 'admin_application'

  def index
    @book_details = BookDetail.all
  end

  def new_index
    @book_details = BookDetail.where('release >= ?', Date.today )
  end

  def new
    @book_detail = BookDetail.new
  end

  def create
    @book_detail = BookDetail.new(book_detail_params)
    if @book_detail.save
      redirect_to admin_book_detail_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @book_detail.update(book_detail_params)
      redirect_to admin_book_detail_url, success: "タスク「#{@book_detail.title}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @book_detail.destroy
    redirect_to admin_books_path, success: "タスク「#{@book.title}」を削除しました。"
  end

  private

  def book_detail_params
    params.require(:book_detail).permit(:title, :title_kana, :volume, :page, :release, :amazon_url, :rakuten_url)
  end

  def set_book_detail
    @book_detail = BookDetail.find(params[:id])
  end

end

