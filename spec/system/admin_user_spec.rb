require 'rails_helper'

RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:admin_user)
    FactoryBot.create(:book)
  end
  describe "管理画面のテスト" do
    context "管理者登録をしている場合" do
      before do
        visit new_user_session_path
      end
      it "管理者は管理画面にアクセスできること" do
        fill_in 'user_email', with: 'admin@example.com'
        fill_in 'user_password', with: 'password'
        find(:xpath, '/html/body/div[2]/form/div[4]/input').click
        visit admin_books_path
        expect(current_path).to eq admin_books_path
      end
      it "一般ユーザは管理画面にアクセスできないこと" do
        fill_in 'user_email', with: 'sample@example.com'
        fill_in 'user_password', with: 'password'
        find(:xpath, '/html/body/div[2]/form/div[4]/input').click
        visit admin_books_path
        expect(current_path).to eq books_path
      end
    end
    context "管理者登録をしている場合" do
      before do
        visit new_user_session_path
        fill_in 'user_email', with: 'admin@example.com'
        fill_in 'user_password', with: 'password'
        find(:xpath, '/html/body/div[2]/form/div[4]/input').click
        visit admin_books_path
      end
      it "管理者は本の編集ができること" do
        click_on "編集"
        fill_in "book_title", with: "change_title"
        click_on "登録する"
        expect(page).to have_content "change_title"
      end
      it "管理者は本の削除をできること" do
        click_link "削除"
        page.accept_confirm
        visit admin_books_path
        expect(page).to have_no_content "ああ無情"
      end
    end
  end
end