require 'rails_helper'

RSpec.describe "本詳細時登録時のテスト", type: :model do
  before do
    FactoryBot.create(:book)
  end
  it "titleがからならバリデーションが通らない" do
    book_detail = BookDetail.new(title: '', title_kana: 'あ', volume: 1, page: 1, release: Date.today)
    expect(book_detail).not_to be_valid
  end
end
