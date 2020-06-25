require 'rails_helper'

RSpec.describe '通知登録機能', type: :system do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:book)
    FactoryBot.create(:second_book)
    Bookmark.create(user_id: 1, book_id: 1)

  end
  context '1件通知登録をした場合' do
    before do
      visit new_user_session_path
      fill_in 'user_email', with: 'sample@example.com'
      fill_in 'user_password', with: 'password'
      find(:xpath, '/html/body/div[2]/form/div[4]/input').click
      visit books_path
    end
    it '通知一覧に登録した本存在する' do
      visit bookmarks_index_books_path
      expect(page).to have_content "ああ無情"
    end
    it '通知登録を削除できる' do
      visit bookmarks_index_books_path
      click_on '通知登録を解除する'
      visit bookmarks_index_books_path
      expect(page).to have_no_content "ああ無情"
    end
    it '通知登録できる' do
      click_on '通知登録する'
      visit bookmarks_index_books_path
      expect(page).to have_content "異世界ですが魔物栽培してます"
    end
  end
end
