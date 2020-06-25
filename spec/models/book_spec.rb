require 'rails_helper'

RSpec.describe '本検索機能', type: :model do
  describe "本登録時のテスト"do
    it "titleがからならバリデーションが通らない" do
      book = Book.new(title: '', title_kana: 'あ', author: 'あ', label: 'あ', issue_from: 'あ')
      expect(book).not_to be_valid
    end
  end
  describe "本検索時のテスト" do
    context 'scopeメソッドで検索をした場合' do
      before do
        FactoryBot.create(:book)
        FactoryBot.create(:second_book)
        FactoryBot.create(:third_book)
      end
      it "scopeメソッドでtitle_kanaの先頭検索ができる" do
        expect(Book.syllabary_like("あ").count).to eq 1
      end
      it "scopeメソッドでタイトル検索（漢字）ができる" do
        expect(Book.title_like("異世界").count).to eq 1
      end
      it "scopeメソッドでタイトル検索（平仮名）ができる" do
        expect(Book.title_like("いせかい").count).to eq 1
      end
      it "scopeメソッドでタイトル検索（カタカナを平仮名に変換して）検索できる" do
        expect(Book.title_like("イセカイ").count).to eq 1
      end
    end
  end
end