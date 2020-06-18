class BookmarksController < ApplicationController
  def create
    current_user.bookmarks.create(book_id: params[:book_id])
    redirect_to books_path, success: "通知登録をしました"
  end

  def destroy
    current_user.bookmarks.find_by(book_id: params[:book_id]).destroy
    redirect_to books_path, success: "通知登録を解除しました"
  end
end
