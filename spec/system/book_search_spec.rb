require 'rails_helper'

RSpec.describe 'タスク検索機能', type: :system do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:book)
    FactoryBot.create(:second_book)
  end
  context '検索をした場合' do
    before do
      visit new_user_session_path
      fill_in 'user_email', with: 'sample@example.com'
      fill_in 'user_password', with: 'password'
      find(:xpath, '/html/body/div[2]/form/div[4]/input').click
      visit books_path
    end
    it "五十音検索ができる" do
      page.first("#a_search").click
      expect(page).to have_content 'ああ無情'
    end
    it "タイトル検索（漢字）ができる" do
      visit books_path
      fill_in "title_search", with: '異世界'
      click_on '検索'
      expect(page).to have_content '異世界ですが魔物栽培してます'
    end
    it "タイトル検索（平仮名）ができる" do
      visit books_path
      fill_in "title_search", with: 'いせかい'
      click_on '検索'
      expect(page).to have_content '異世界ですが魔物栽培してます'
    end
    it "タイトルとステータスとラベルで検索できる" do
      visit books_path
      fill_in "title_search", with: 'イセカイ'
      click_on '検索'
      expect(page).to have_content '異世界ですが魔物栽培してます'
    end
  end
end

