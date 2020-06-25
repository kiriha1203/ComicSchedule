require 'rails_helper'

RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do
  describe 'ユーザ登録のテスト' do
    context 'ユーザのデータがなくログインしていない場合' do
      it 'ユーザ新規登録のテスト' do
        visit new_user_registration_path
        fill_in 'user_name', with: 'sample'
        fill_in 'user_email', with: 'sample@example.com'
        fill_in 'user_password', with: '00000000'
        choose 'user_sex_woman'
        fill_in 'user_password_confirmation', with: '00000000'
        click_on 'アカウント登録'
        expect(current_path).to eq books_path
      end
      it 'ログインしていない時はログイン画面に飛ぶテスト' do
        visit books_path
        expect(current_path).to eq new_user_session_path
      end
    end
  end
   describe 'セッション機能のテスト' do
     context 'ユーザー登録をしている場合' do
       before do
         FactoryBot.create(:user)
         FactoryBot.create(:admin_user)
         visit new_user_session_path
         fill_in 'user_email', with: 'sample@example.com'
         fill_in 'user_password', with: 'password'
         find(:xpath, '/html/body/div[2]/form/div[4]/input').click
       end
       it 'ログインできること' do
         expect(current_path).to eq books_path
       end
       it '自分の詳細画面(マイページ)に飛べること' do
         visit user_path(id: 1)
         expect(current_path).to eq user_path(id: 1)
       end
       it "一般ユーザが他人の詳細画面に飛ぶとタスク一覧ページに遷移すること" do
         visit user_path(id: 3)
         expect(current_path).to eq books_path
       end
       it "ログアウトができること" do
         click_on "ログアウト"
         expect(current_path).to eq new_user_session_path
       end
     end
   end
 end
